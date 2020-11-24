extends Area2D

signal hit 

export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = velocity.y > 0
		$AnimatedSprite.flip_h = velocity.x > 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
	#stop motion of all bodies
	var preDeathSpeed = self.speed
	self.speed = 0
	get_tree().call_group("mobs", "stop_movement")
	
	#end game
	$AnimatedSprite/AnimationPlayer.play("Flash White")
	emit_signal("hit")
	$DeathSound.play()
	yield(get_tree().create_timer($AnimatedSprite/AnimationPlayer.get_animation("Flash White").length), "timeout")
	hide()
	self.speed = preDeathSpeed 	#don't want 0 speed when restarting, derp.
	
	#N.B. if we weren't setting v = 0, would need this to prevent
	#     subsequent collision detection
	#$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

extends RigidBody2D

var min_speed = 150
var max_speed = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func stop_movement():
	self.linear_velocity = Vector2(0,0)

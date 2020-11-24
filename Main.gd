extends Node

export (PackedScene) var Mob
var score

func _ready():
	randomize()

func game_over():
	$Music.stop()
	var animationNode = $Player/AnimatedSprite/AnimationPlayer
	yield(get_tree().create_timer(animationNode.get_animation("Flash White").length), "timeout")
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("mobs", "queue_free")
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready...")
	$Music.play()


func _on_mobTimer_timeout():
	$MobPath/MobSpawnLoc.offset = randi()
	var mob = Mob.instance()
	add_child(mob)
	var direction = $MobPath/MobSpawnLoc.rotation + PI / 2 #perpendicular to path direction, radians.
	mob.position = $MobPath/MobSpawnLoc.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	mob.linear_velocity =  Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)


func _on_ScoreTimer_timeout():
	score += 5
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

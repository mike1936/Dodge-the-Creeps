extends Node

export (PackedScene) var Mob
var score

func _ready():
	# randi depend on this to function
	randomize()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	# Start timer (shot once) -> mob timer (loop every 0.5 sec)
	#                         -> score timer (loop every 1 sec)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_some_message("Get Ready")
	$Music.play()

func _on_StartTimer_timeout():
	# Wait ($StartTimer.Wait_Time=) 2 until other timer start:
	$ScoreTimer.start()
	$MobTimer.start()

func _on_ScoreTimer_timeout():
	# Every ($ScoreTime.Wait_time=) 1 s, add 1 score:
	score += 1
	$HUD.update_score(score)

func _on_MobTimer_timeout():
	# Every ($MobTimer.Wait_time=) 0.5 s, do following:
	
	# Choose a random location on Path2D 
	$MobPath/MobSpawnLocation.set_offset(randi())
	# Add mob child instance to Main scene
	var mob = Mob.instance()
	add_child(mob)
	# Mob direction set: (PI/2 radians = 90 degrees) with randomness
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	direction += rand_range(- PI / 4, PI / 4)
	
	# Set moblocation and direction
	mob.position = $MobPath/MobSpawnLocation.position
	mob.rotation = direction
	mob.set_linear_velocity(Vector2(rand_range(mob.min_speed, mob.max_speed), 0).rotated(direction))

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Player.hide()
	$Music.stop()
	$DeathSound.play()

func _process(delta):
	$DEBUG.text = str($MobTimer.is_stopped()) + ', ' + str($StartTimer.time_left)

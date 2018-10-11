extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (PackedScene) var Mob
var score

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	# randi depend on this to function
	randomize()
	new_game()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	# Start timer (shot once) -> mob timer (loop every 0.5 sec)
	#                         -> score timer (loop every 1 sec)
	$StartTimer.start()

func _on_StartTimer_timeout():
	# Wait ($StartTimer.Wait_Time=) 2 until other timer start:
	$ScoreTimer.start()
	$MobTimer.start()

func _on_ScoreTimer_timeout():
	# Every ($ScoreTime.Wait_time=) 1 s, add 1 score:
	score += 1

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

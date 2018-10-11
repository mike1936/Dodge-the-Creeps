extends Area2D
# Use signal allows us to set Signal
signal hit
# Use export allows us to set its value in the Inspector
export (int) var speed  # How fast the player will move(pixel/sec)
var screensize

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	screensize = get_viewport_rect().size
	hide()

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	var velocity = Vector2() # The player's move vector
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	# Update position of the player
	self.position += velocity * delta
	# Restrict position area
	self.position.x = clamp(position.x, 0, screensize.x)
	self.position.y = clamp(position.y, 0, screensize.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = 'right'
		if velocity.y ==0:
			$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = 'up'
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.disabled = true # Make sure hit only once

# Restart and show the player
func start(pos):
	self.position = pos
	show()
	$CollisionShape2D.disabled = false

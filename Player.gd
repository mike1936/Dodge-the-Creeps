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
		$RainbowPhantom.texture = $AnimatedSprite.frames.get_frame($AnimatedSprite.animation, $AnimatedSprite.frame)
		$RainbowPhantom.set_emitting(true)
		if velocity.y >= 0:
			$AnimatedSprite.animation = 'right'
			if velocity.x < 0:
				var t = ImageTexture.new()
				var i = Image.new()
				i = $RainbowPhantom.texture.get_data()
				i.flip_x()
				t.create_from_image(i)
				$RainbowPhantom.texture = t
				$AnimatedSprite.flip_h = true
			else:
				$RainbowPhantom.texture = $AnimatedSprite.frames.get_frame($AnimatedSprite.animation, $AnimatedSprite.frame)
				$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.animation = 'up'
	else:
		$AnimatedSprite.stop()
		$RainbowPhantom.set_emitting(false)
	
	# Update position of the player
	self.position += velocity * delta
	# Restrict position area
	self.position.x = clamp(position.x, 0, screensize.x)
	self.position.y = clamp(position.y, 0, screensize.y)

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.disabled = true # Make sure hit only once

# Restart and show the player
func start(pos):
	self.position = pos
	show()
	$CollisionShape2D.disabled = false

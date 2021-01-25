extends KinematicBody2D

# Paper Texture by Vecteezy at https://www.vecteezy.com/photo/1227815-white-crumpled-paper 
# Music 1 is Moving in Frozen Time Pt. 6 from https://www.onemansymphony.com/
# End Music is Mohnfield (Part 1) from https://www.onemansymphony.com/

# Whether the attack animation is playing or not
var attacking : bool = false

# Whether the hurt animation if playing or not
var hurting : bool = false

# Whether the player is invincible (after hit)
var invincible : bool = false

# The sprites to be used
onready var isprite : Sprite = get_node("Idle")
onready var asprite : Sprite = get_node("Attack")
onready var resprite : Sprite = get_node("ExplosionRight")
onready var lesprite : Sprite = get_node("ExplosionLeft")
onready var hsprite : Sprite = get_node("Hurt")

# The currect player score
var score : int = 0

# Direction: 1 if right, -1 if left
var direction : int = 1

# Speed in each direction
var up : int = 0
var down : int = 0
var right : int = 0
var left : int = 0

# The base speed to start out with
var base_speed : int = 200

# The max speed achieved
var max_speed : int = 600

# The acceleration for movement
var acceleration : float = 1.3

# Velocity vector
var vel : Vector2 = Vector2()

func _ready():
	# Only show idle at first
	GameManager.target = self.global_position
	GameManager.attacker = false
	GameManager.player = self
	isprite.visible = true
	asprite.visible = false
	resprite.visible = false
	lesprite.visible = false
	hsprite.visible = false

func _process(delta):
	score = GameManager.score
	
	# Tell game manager script what the position is
	GameManager.target = self.global_position
	
	# If the attack animation is not playing and the attack button is not
	# pressed, play the idle animation
	if Input.is_action_just_pressed("attack") == false and attacking == false and hurting == false:
		$AnimationPlayer.play("Idle")

	if Input.is_action_just_pressed("attack"):
		# If the attack button is pressed AND there is not an attack in progress
		if attacking == false and GameManager.end == false and hurting == false:
			isprite.visible = false
			asprite.visible = true
			attacking = true
			GameManager.attacker = true
			$AttackSound.play()
			$AttackTimer.start()
			$AttackTimer2.start()
			if asprite.flip_h == true:
				$AnimationPlayer.play("AttackLeft")
			else:
				$AnimationPlayer.play("AttackRight")
			
	if Input.is_action_pressed("move_right"):
		if right < 30:
			right = base_speed
		if right < max_speed:
			right *= acceleration
		direction = 1
		isprite.flip_h = false
		asprite.flip_h = false
		hsprite.flip_h = false
	if Input.is_action_pressed("move_down"):
		if down < 30:
			down = base_speed
		if down < max_speed:
			down *= acceleration
	if Input.is_action_pressed("move_left"):
		if left > -30:
			left = -1 * base_speed
		if left > -1 * max_speed:
			left *= acceleration
		direction = -1
		isprite.flip_h = true
		asprite.flip_h = true
		hsprite.flip_h = true
	if Input.is_action_pressed("move_up"):
		if up > -30:
			up = -1 * base_speed
		if up > -1 * max_speed:
			up *= acceleration
	
	# Friction slowing down the slide
	if down > 30:
		down -= 20
	if up < -30:
		up += 20
	if right > 30:
		right -= 20
	if left < -30:
		left += 20
	
	# Adds up the horizontal and vertical velocity
	vel.x = left + right
	vel.y = up + down
	
	# Prevents sliding by stopping movement under a certain point
	if vel.x < 30 and vel.x > -30:
		vel.x = 0;
	if vel.y < 30 and vel.y > -30:
		vel.y = 0;
	
	vel = move_and_slide(vel, Vector2(0, 0))

# Reset visible the idle animation and set attacking to false
func _on_AttackTimer_timeout():
	GameManager.attacker = false
	attacking = false
	asprite.visible = false
	lesprite.visible = false
	resprite.visible = false
	if hurting == false:
		isprite.visible = true

func _on_AttackTimer2_timeout():
	$AttackSound.stop()

func _on_HurtArea_body_entered(body):
	if body.get_class() == "KinematicBody2D" and hurting == false and invincible == false and body.name != "PlayerThumb":
		if body.killed == false:
			hurting = true
			invincible = true
			GameManager.health -= 1
			isprite.visible = false
			asprite.visible = false
			hsprite.visible = true
			$HurtTimer.start()
			$InvincibleTimer.start()
			$AnimationPlayer.play("Hurt")

func _on_InvincibleTimer_timeout():
	invincible = false

func _on_HurtTimer_timeout():
	hurting = false
	$AnimationPlayer.stop()
	isprite.visible = true
	asprite.visible = false
	hsprite.visible = false

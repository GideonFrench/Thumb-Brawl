extends KinematicBody2D

# The speed in which it chases player
var speed : int = 200

# Whether the player is detected or not
var detected : bool = false

# Whether the enemy is being killed
var killed : bool = false

# Whether the enemy is being alerted
var alerted : bool = false

# The positon of the player
#var target : Vector2 = GameManager.target

# Sprites to be used
onready var wsprite : Sprite = get_node("Walking")
onready var asprite : Sprite = get_node("Alert")
onready var isprite : Sprite = get_node("Idle")
onready var dsprite : Sprite = get_node("Death")

func _ready():
	asprite.visible = false
	isprite.visible = true
	wsprite.visible = false
	dsprite.visible = false
	$AlertPlayer.stop()

func _on_AlertTimer_timeout():
	alerted = false
	asprite.visible = false
	$AlertPlayer.stop()

func _process(delta):
	#if $DetectionArea.overlaps_area(player.get_node("DetectArea")):
	
	if GameManager.player.get_node("DetectArea").overlaps_area($DetectionArea):
		if detected == false:
			alerted = true
			$AlertTimer.start()
		detected = true
		
	if alerted:
		asprite.visible = true
		$AlertPlayer.play("Alert")
	
	if detected == true and killed == false and GameManager.end == false:
		isprite.visible = false
		wsprite.visible = true
		if pow((pow((GameManager.target.x - position.x), 2) + pow((GameManager.target.y - position.y), 2)), 0.5) > 140:
			position = position.move_toward(GameManager.target, delta*speed)
		$AnimationPlayer.play("Walk")
		# Flip if the player is to the left
		if self.global_position.x > GameManager.target.x:
			wsprite.flip_h = true
			dsprite.flip_h = true
		else:
			wsprite.flip_h = false
			dsprite.flip_h = false
	elif killed == false:
		isprite.visible = true
		$AnimationPlayer.play("Idle")
	
	
	# If the enemy is in the attack range, kill it
	if GameManager.attacker == true:
		if GameManager.player.direction == 1 and $HitArea.overlaps_area(GameManager.player.get_node("AttackZoneRight")):
			killed = true
			$AnimationPlayer.play("Death")
		elif GameManager.player.direction == -1 and $HitArea.overlaps_area(GameManager.player.get_node("AttackZoneLeft")):
			killed = true
			$AnimationPlayer.play("Death")


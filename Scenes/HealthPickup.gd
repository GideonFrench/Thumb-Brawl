extends Node2D

onready var hsprite : AnimatedSprite = get_node("HealthSprite")

func _ready():
	hsprite.visible = true

#func _process(delta):
#	pass

func _on_HealthPickupArea_body_entered(body):
	if body.name == "PlayerThumb":
		if GameManager.health < 3:
			GameManager.health += 1
			$AnimationPlayer.play("PickupHealth")
		else:
			$FullSound.play()
			$FullSoundTimer.start()

func _on_FullSoundTimer_timeout():
	$FullSound.stop()

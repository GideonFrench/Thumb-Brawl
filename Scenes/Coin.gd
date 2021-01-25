extends Node2D

onready var csprite : AnimatedSprite = get_node("CoinSprite")

func _ready():
	csprite.visible = true

#func _process(delta):
#	pass


func _on_PickupArea_body_entered(body):
	if body.name == "PlayerThumb":
		GameManager.score += 1
		$AnimationPlayer.play("Pickup")

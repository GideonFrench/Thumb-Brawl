extends Node2D

var music_playing : bool = false

onready var esprite : AnimatedSprite = get_node("EndSprite")
onready var asprite = get_node("AnimatedPaper")

func _ready():
	GameManager.endscreen = self
	esprite.visible = false
	asprite.visible = false
	$EndMusic.stop()

func end():
	self.visible = true
	esprite.visible = true
	asprite.visible = true
	if music_playing == false:
		music_playing = true
		$EndMusic.play()

extends Node2D

var wipe_on : bool = false

func _ready():
	self.visible = false
	wipe_on = false
	GameManager.wiper = self

func wipe():
	self.visible = true
	if wipe_on == false:
		wipe_on = true
		$WipeTimer.start()
		$AnimationPlayer.play("Wipe")
		
func wipe_end():
	self.visible = true
	if wipe_on == false:
		wipe_on = true
		$WipeTimer2.start()
		$AnimationPlayer.play("Wipe")
		
func _on_WipeTimer_timeout():
	get_tree().reload_current_scene()

func _on_WipeTimer2_timeout():
	self.visible = false
	$WipeSprite.visible = false
	$AnimationPlayer.stop()
	GameManager.endscreen.end()

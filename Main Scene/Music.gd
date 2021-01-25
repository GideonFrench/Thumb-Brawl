extends AudioStreamPlayer

func _process(delta):
	if GameManager.end:
		self.stop()

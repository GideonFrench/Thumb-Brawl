extends AnimatedSprite

func _ready():
	self.visible = false

func _process(delta):
	if GameManager.score > 6:
		self.visible = true
	else:
		self.visible = false

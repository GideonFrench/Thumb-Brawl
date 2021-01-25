extends AnimatedSprite

func _ready():
	self.visible = true

func _process(delta):
	if GameManager.health < 1:
		self.visible = false
	else:
		self.visible = true

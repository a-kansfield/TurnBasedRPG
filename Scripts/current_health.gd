extends Label

var pos : int

func _ready():
	SignalBus.projectCurrentHealth.connect(setText)
	
func setText(pos: int, value: int):
	print("Set Text Called")
	if self.pos == pos:
		self.text = str(value)
	

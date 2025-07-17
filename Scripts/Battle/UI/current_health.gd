extends Label

var pos : int

func _ready():
	Battle_SB.projectCurrentHealth.connect(setText)
	
func setText(pos: int, value: int):
	if self.pos == pos:
		self.text = str(value)
	

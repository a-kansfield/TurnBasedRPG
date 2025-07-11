extends Sprite2D

var color : Color
func _ready():
	if color != null:
		modulate = color

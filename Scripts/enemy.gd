extends Node2D

var keyName : String = "Default"
var pos : int


func _ready():
	SignalBus.entityDestroyed.connect(destroySelf)
	

func destroySelf(pos):
	if self.pos == pos:
		queue_free()

# Unused - with a random number generator it can modulate the sprite color
#func randomColorGen(rng : RandomNumberGenerator):
	#var r = rng.randi_range(0, 255)
	#var g = rng.randi_range(0, 255)
	#var b = rng.randi_range(0, 255)
	#self.color = Color.from_rgba8(r,g,b,255)
	#modulate = color

extends Node2D

var keyName : String = "Default"
var pos : int
var affiliation = "Enemy"

func _init():
	add_to_group("battleEnemies")
func _ready():
	SignalBus.entityDestroyed.connect(destroySelf)
	# Ok so apparently scene groups just refuse to work so we're gonna try global groups which is ass but ugh
	
	

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

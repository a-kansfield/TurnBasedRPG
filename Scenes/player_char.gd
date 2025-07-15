extends Node2D

var pos : int
var affiliation = "Player"

func _init():
	add_to_group("battlePlayers")
	SignalBus.entityDestroyed.connect(destroySelf)
	
func destroySelf(pos):
	if self.pos == pos:
		queue_free()

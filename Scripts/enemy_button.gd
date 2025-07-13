extends Button

var keyName : String
var pos : int

var enemyFactoryScript = preload("res://Scripts/enemy_factory.gd")

signal enemy_button_button_up(key)

func _ready():
	SignalBus.entityDestroyed.connect(remove)

func _on_button_up():
	#enemy_button_button_up.emit(keyName)
	
	SignalBus.changeEntityHealth.emit(pos, -2)
	pass # Replace with function body.

func remove(pos):
	
	if self.pos == pos:
		queue_free()

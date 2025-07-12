extends Button

var keyName : String
var id : int

var enemyFactoryScript = preload("res://Scripts/enemy_factory.gd")

signal enemy_button_button_up(key)

func _ready():
	SignalBus.enemyDestroyed.connect(remove)
	
	
	print(enemyFactoryScript.ENEMY_Y_OFFSET)

func _on_button_up():
	enemy_button_button_up.emit(keyName)
	
	SignalBus.enemyDestroyed.emit(id)
	print("Keyname from Enemy Button: ", keyName)
	print("ID from Enemy Button: ", id)
	pass # Replace with function body.

func remove(id):
	
	if self.id == id:
		print("Enemy Removed")
		queue_free()

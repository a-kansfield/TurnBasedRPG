extends Button

var keyName : String


var enemyFactoryScript = preload("res://Scripts/enemy_factory.gd")

signal enemy_button_button_up(key)

func _ready():
	
	print(enemyFactoryScript.ENEMY_Y_OFFSET)

func _on_button_up():
	enemy_button_button_up.emit(keyName)
	print("Keyname from Enemy Button: ", keyName)
	pass # Replace with function body.

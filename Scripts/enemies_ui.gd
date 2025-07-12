extends VBoxContainer
#############################################
# Instantiates UI for each enemy via Signal (from Enemy Factory)

# Dependencies
var enemyButtonScene = preload("res://Scenes/enemy_button.tscn")

var enemyKeys : Array

# Signal from Enemy Factory - creates a button that matches the 
func _on_enemy_factory_enemy_spawned(instance, enemyChildren):
	var btn = enemyButtonScene.instantiate()
	
	# Alter Button Aspects
	btn.text = instance.get_child(enemyChildren.STATS).eName
	btn.keyName = instance.keyName
	
	enemyKeys.append(btn.keyName)
	print(enemyKeys)
	
	# Connect button to both enemy list and enemy factory.
	#TODO: Set up a hub for this because this is a nightmare
	btn.connect("enemy_button_button_up", _on_enemy_button_button_up)
	btn.connect("enemy_button_button_up", $"../../../../EnemyFactory"._on_enemy_button_button_up) # This sucks ass don't do this
	
	add_child(btn)

func _on_enemy_button_button_up(keyName : String):
	#print("From EnemyList UI: ", keyName)
	print(get_tree().root)
	

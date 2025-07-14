extends VBoxContainer
#############################################
# Instantiates UI for each enemy via Signal (from Enemy Factory)

# Dependencies
var enemyButtonScene = preload("res://Scenes/enemy_button.tscn")



var enemyKeys : Array	# List of enemies in the battle by their dictionary keys

func _init():
	SignalBus.enemySpawned.connect(_on_enemy_spawned)

func _ready():
	#SignalBus.enemySpawned.connect(_on_enemy_spawned)
	pass


# Signal from Enemy Factory - creates a button that matches the generated enemy
func _on_enemy_spawned(instance, pos):
	var btn = enemyButtonScene.instantiate()
	
	# Alter Button Aspects
	btn.text = instance.get_child(Globals.enemyChildren.STATS).eName
	btn.keyName = instance.keyName
	btn.pos = pos
	
	enemyKeys.append(btn.keyName)
	
	add_child(btn)

#func _on_enemy_button_button_up(keyName : String):
	##print("From EnemyList UI: ", keyName)
	#print(get_tree().root)
	

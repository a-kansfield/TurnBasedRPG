extends VBoxContainer
#############################################
# Instantiates UI for each enemy via Signal (from Enemy Factory)

# Dependencies
var enemyButtonScene = preload("res://Scenes/enemy_button.tscn")


func _on_enemy_factory_enemy_spawned(instance, enemyChildren):
	var btn = enemyButtonScene.instantiate()
	
	# Alter Button Aspects
	btn.text = instance.get_child(enemyChildren.STATS).eName
	
	add_child(btn)

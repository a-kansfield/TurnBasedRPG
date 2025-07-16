extends VBoxContainer
#############################################
# Instantiates UI for each enemy via Signal (from Enemy Factory)

# Dependencies
var enemyButtonScene = preload("res://Scenes/enemy_button.tscn")



var enemyKeys : Array	# List of enemies in the battle by their dictionary keys

func _init():
	SignalBus.enemySpawned.connect(_on_enemy_spawned)
	SignalBus.playerTurn.connect(_on_player_turn)
	SignalBus.enemyTurn.connect(_on_enemy_turn)
	
func _ready():
	#SignalBus.enemySpawned.connect(_on_enemy_spawned)
	print("Root Node Array from Enemies List: ", self.owner.activeEnemies)
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

func _on_player_turn(activeEntity, enemyEntities):
	self.visible = true
	
	
func _on_enemy_turn(activeEntity, playerEntities):
	self.visible = false

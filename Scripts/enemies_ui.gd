extends VBoxContainer
#############################################
# Instantiates UI for each enemy via Signal (from Enemy Factory)

# Dependencies
var enemyButtonScene = preload("res://Scenes/enemy_button.tscn")



var enemyKeys : Array	# List of enemies in the battle by their dictionary keys

func _init():
	Battle_SB.enemySpawned.connect(_on_enemy_spawned)
	Battle_SB.playerTurn.connect(_on_player_turn)
	Battle_SB.enemyTurn.connect(_on_enemy_turn)
	Battle_SB.playerAttack.connect(func(a): _on_player_attack())
	
func _ready():
	
	enableButtons() # Sets all buttons to be enabled at the start


# Signal from Enemy Factory - creates a button that matches the generated enemy
func _on_enemy_spawned(instance, pos):
	var btn = enemyButtonScene.instantiate()
	
	# Alter Button Aspects
	btn.text = instance.get_child(Globals.enemyChildren.STATS).eName
	btn.keyName = instance.keyName
	btn.pos = pos
	
	enemyKeys.append(btn.keyName)
	
	add_child(btn)


# Cycles through all enemy buttons and disables or enables as needed. Enebled at player turn start, and disabled after player turn attack.

func enableButtons():
	var buttons = get_children()
	for i in buttons:
		i.disabled = false
		
func disableButtons():
	var buttons = get_children()
	for i in buttons:
		i.disabled = true
			
func _on_player_turn(activeEntity, enemyEntities):
	self.visible = false
	enableButtons()
	
	
func _on_player_attack():
	disableButtons()
	self.visible = false;
	
func _on_enemy_turn(activeEntity, playerEntities):
	self.visible = false


func _on_attack_btn_button_up():
	self.visible = !self.visible
	enableButtons()
	pass # Replace with function body.

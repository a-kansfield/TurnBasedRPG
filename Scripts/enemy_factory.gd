extends Node2D
############################################################
# Handles the creation of enemies at battle start.
# Dependencies: A tres file holding a dictionary of all enemy types
#				The Enemy Node scene
#
# TODO: Add labels for each enemy -- DONE
# TODO: Handle enemy removal
# TODO: Realization: Dictionary keys wont be enough because there can be multiple of the same type of enemy. Will need to add an array of unique references.
# TODO: Currently - the enemies are spawning before the UI has a chance to connect via signal. I may want to look other solutions (Another signal to emit once everything is loaded?)
# Dependencies
var enemyScene = preload("res://Scenes/enemy.tscn")
var enemyData = preload("res://Data/EnemyData.tres")


# Constants
var rng = RandomNumberGenerator.new()
enum enemyChildren {SPRITE = 0, STATS = 1}	# Note: Adjust as children are added to Enemy.tscn

const ENEMY_Y_OFFSET : int = 180
const ENEMY_Y_SPACING : int = 200			# Multiplied by position to evenly space all enemies
const ENEMY_X_OFFSET : int = -150

@onready var VIEW_WIDTH : int = get_window().size[0]

# Starting Enemies are kept track of to determine things like experience earned. Active is tracked separately and can also be considered "living" enemies
var startingEnemies : Array
var activeEnemies : Array

func _init():
	pass
	
	
func _ready():
	# Set Signals
	SignalBus.enemyDestroyed.connect(_on_enemy_destroyed)
	var enemyNum = generateNumOfEnemies()	# Determine number of enemies in battle
	placeEnemies(enemyNum)
	

# Generate number of enemies
func generateNumOfEnemies() -> int: 
	return rng.randi_range(1,3)


# Cycle through enemy positions to generate a random enemy from the dictionary list of all enemies, then instantiate
func placeEnemies(enemyNum : int):
	for i in range(enemyNum):
		var inst = setPosition(i)
		inst = generateEnemyType(inst)		# Using EnemyData.tres/gd - will randomly generate a statblock from the enemy dictionary
		inst.id = i
		#Add unique references to Enemies
		startingEnemies.append(inst)
		activeEnemies.append(inst)	
		
		SignalBus.enemySpawned.emit(inst, i, enemyChildren) # 
		add_child(inst)
		
		


# Sets the x and y value of the enemy
func setPosition(pos : int) -> Variant:
	var inst = enemyScene.instantiate()
	inst.position.y = (pos * ENEMY_Y_SPACING) + ENEMY_Y_OFFSET
	inst.position.x = VIEW_WIDTH + ENEMY_X_OFFSET
	return inst

# Uses dictionary from EnemyData to randomly select an enemy type - then instantiates
func generateEnemyType(inst : Variant) -> Variant:
	var keys = enemyData.EnemyTable.keys() 					# Get all keys in dictionary
	var enemyKey = keys[rng.randi_range(0, (keys.size()) -1)]	# Key for the specific enemy generated
	
	# Store Enemy Children
	var spr = inst.get_child(enemyChildren.SPRITE)
	var stats = inst.get_child(enemyChildren.STATS)
	
	inst.keyName = enemyKey
	
	# Set Enemy Stats
	stats.eName = enemyData.EnemyTable[enemyKey].name
	stats.strength = enemyData.EnemyTable[enemyKey].strength
	stats.health = enemyData.EnemyTable[enemyKey].health
	spr.color = enemyData.EnemyTable[enemyKey].color
	
	return inst
	
func _on_enemy_destroyed(enemyPos : int):
	pass

# Only runs once everything is loaded
func _on_battle_ready():
	#var enemyNum = generateNumOfEnemies()	# Determine number of enemies in battle
	#placeEnemies(enemyNum)
	pass # Replace with function body.

extends Node2D
############################################################
# Handles the creation of enemies at battle start.
# Dependencies: A tres file holding a dictionary of all enemy types
#				The Enemy Node scene
#
# TODO: Add labels for each enemy
# TODO: Handle enemy removal

# Dependencies
var enemyScene = preload("res://Scenes/enemy.tscn")
var allEnemies = preload("res://Data/EnemyData.tres")

# Constants
var rng = RandomNumberGenerator.new()
enum enemyChildren {SPRITE = 0, STATS = 1}	# Note: Adjust as children are added to Enemy.tscn
const ENEMY_Y_SPACING : int = 180			# Multiplied by position to evenly space all enemies

# Signals
#signal enemySpawned(instance : Variant)

func _init():
	pass
	
	
func _ready():
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
		#print(inst.get_child(enemyChildren.STATS).eName)
		add_child(inst)
		#enemySpawned.emit(inst)



func setPosition(pos : int) -> Variant:
	var inst = enemyScene.instantiate()
	inst.position.y = pos * ENEMY_Y_SPACING
	return inst

# Uses dictionary from EnemyData to randomly select an enemy type - then instantiates
func generateEnemyType(inst : Variant) -> Variant:
	var keys = allEnemies.EnemyTable.keys() 					# Get all keys in dictionary
	var enemyKey = keys[rng.randi_range(0, (keys.size()) -1)]	# Key for the specific enemy generated
	
	# Name Enemy Children
	var spr = inst.get_child(enemyChildren.SPRITE)
	var stats = inst.get_child(enemyChildren.STATS)
	
	inst.keyName = enemyKey
	
	# Set Enemy Stats
	stats.eName = allEnemies.EnemyTable[enemyKey].name
	stats.strength = allEnemies.EnemyTable[enemyKey].strength
	stats.health = allEnemies.EnemyTable[enemyKey].health
	spr.color = allEnemies.EnemyTable[enemyKey].color
	
	return inst
	
		
	
	

extends Node2D
############################################################
# Handles the creation of enemies at battle start.
# Including 


var enemyScene = preload("res://Scenes/enemy.tscn")
var allEnemies = preload("res://Data/EnemyData.tres")
var rng = RandomNumberGenerator.new()

const ENEMY_Y_SPACING : int = 180			# Multiplied by position to evenly space all enemies

func _init():
	pass
	
	
func _ready():
	var enemyNum = generateNumOfEnemies()	# Determine number of enemies in battle
	for i in range(enemyNum):				# Cycle through and place enemies
		var inst = positionEnemy(i)			# Instantiate enemy positions
		inst = generateEnemyType(inst)		# Using EnemyData.tres/gd - will randomly generate a statblock from the enemy dictionary
		print(inst.get_child(1).eName)
		add_child(inst)
		#print(inst.keyName)
	

	
#Generate number of enemies
func generateNumOfEnemies() -> int: 
	return rng.randi_range(1,3)
	
func positionEnemy(pos : int) -> Variant:
	var inst = enemyScene.instantiate()
	inst.position.y = pos * ENEMY_Y_SPACING
	
	#add_child(inst)
	return inst

func generateEnemyType(inst : Variant) -> Variant:
	var keys = allEnemies.EnemyTable.keys() 				# Get all keys in dictionary
	var enemyKey = keys[rng.randi_range(0, (keys.size()) -1)]	# Key for the specific enemy generated
	var stats = inst.get_child(1)
	var spr = inst.get_child(0)
	inst.keyName = enemyKey									# Set the instances keyName
	
	
	# Set Enemy Stats
	stats.eName = allEnemies.EnemyTable[enemyKey].name
	stats.strength = allEnemies.EnemyTable[enemyKey].strength
	stats.health = allEnemies.EnemyTable[enemyKey].health
	spr.color = allEnemies.EnemyTable[enemyKey].color
	
	return inst
	
		
	
	

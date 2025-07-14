extends Node2D
############################################################
# Handles the creation of enemies at battle start.
# Dependencies: A tres file holding a dictionary of all enemy types
#				The Enemy Node scene
				
#
# TODO: (Potentially) Look into centralizing enemy removal? As of right now I'm essentially doing two near identical functions at the same time which doesn't feel ideal.
#		Maybe an enemy removal service node that calls removal from the same place?

# TODO: Make labels more detailed to show enemy health
# TODO: Adjust buttons to do damage instead of one-click destroy

var enemyScene = preload("res://Scenes/enemy.tscn")
var enemyLabelScene = preload("res://Scenes/enemy_label.tscn")
var enemyData = preload("res://Data/EnemyData.tres")


# Constants
var rng = RandomNumberGenerator.new()


const ENTITY_Y_OFFSET : int = 180
const ENTITY_Y_SPACING : int = 200			# Multiplied by position to evenly space all enemies
const ENTITY_X_OFFSET : int = -150
const LABEL_Y_OFFSET : int = 5

@onready var VIEW_WIDTH : int = get_window().size[0]

# Starting Enemies are kept track of to determine things like experience earned. Active is tracked separately and can also be considered "living" enemies
var startingEnemies : Array
var activeEnemies : Array

func _init():
	pass
	
	
func _ready():
	var enemyNum = generateNumOfEnemies()	# Determine number of enemies in battle
	placeEnemies(enemyNum)
	
	SignalBus.battleInitComplete.emit(startingEnemies)
	
	
	
# Generate number of enemies
func generateNumOfEnemies() -> int: 
	return rng.randi_range(1,3)

# Cycle through enemy positions to generate a random enemy from the dictionary list of all enemies, then instantiate
func placeEnemies(enemyNum : int):
	
	for i in range(enemyNum):
		var enemyInst = enemyScene.instantiate()
		enemyInst = setPosition(enemyInst, i, ENTITY_Y_SPACING, ENTITY_X_OFFSET, ENTITY_Y_OFFSET)
		enemyInst = generateEnemyType(enemyInst)		# Using EnemyData.tres/gd - will randomly generate a statblock from the enemy dictionary
		enemyInst.pos = i
		
		add_child(enemyInst)
		
		# Create Label
		var labelInst = enemyLabelScene.instantiate()
		labelInst = setPosition(
			labelInst, i, 
			ENTITY_Y_SPACING, 
			ENTITY_X_OFFSET, ENTITY_Y_OFFSET + LABEL_Y_OFFSET
		)
		
		# Set Label text
		var spr = enemyInst.get_child(Constants.enemyChildren.SPRITE)
		var stats = enemyInst.get_child(Constants.enemyChildren.STATS)
		var health = enemyInst.get_child(Constants.enemyChildren.HEALTH)
		
		labelInst.pos = i
		labelInst.totalHealth = health.totalHealth
		labelInst.currentHealth = health.currentHealth
		labelInst.entityName = stats.eName
		
		add_child(labelInst)
		
		SignalBus.enemySpawned.emit(enemyInst, i)
		
		#Add unique references to Enemies (Currently unused but maybe necessary later)
		startingEnemies.append(enemyInst)
		activeEnemies.append(enemyInst)	
		

# Sets the x and y value of the enemy
func setPosition(entity : Variant, pos : int, Y_SPACING : int, X_OFFSET : int,  Y_OFFSET : int ) -> Variant:
	#var inst = enemyScene.instantiate()
	entity.position.y = (pos * Y_SPACING) + Y_OFFSET
	entity.position.x = VIEW_WIDTH + X_OFFSET
	return entity

# Sets the x and y value of the label (Note: can easily be refactored to include set enemy position - but I will hold off for now)
#func setLabelPosition(pos : int):
	#
	#var LABEL_OFFSET = 0
	#label.position.y = (pos * ENEMY_Y_SPACING) + ENEMY_Y_OFFSET + LABEL_OFFSET
	#label.position.x = VIEW_WIDTH + ENEMY_X_OFFSET
	#return label

# Uses dictionary from EnemyData to randomly select an enemy type - then instantiates
func generateEnemyType(inst : Variant) -> Variant:
	var keys = enemyData.EnemyTable.keys() 					# Get all keys in dictionary
	var enemyKey = keys[rng.randi_range(0, (keys.size()) -1)]	# Key for the specific enemy generated
	
	# Store Enemy Children
	var spr = inst.get_child(Constants.enemyChildren.SPRITE)
	var stats = inst.get_child(Constants.enemyChildren.STATS)
	var health = inst.get_child(Constants.enemyChildren.HEALTH)
	
	inst.keyName = enemyKey
	
	# Set Enemy Stats
	stats.eName = enemyData.EnemyTable[enemyKey].name
	stats.strength = enemyData.EnemyTable[enemyKey].strength
	stats.health = enemyData.EnemyTable[enemyKey].health	# Note: May not need in the future, but for now I like having it here still
	stats.dexterity = enemyData.EnemyTable[enemyKey].dexterity
	# Set Enemy Health
	health.totalHealth = enemyData.EnemyTable[enemyKey].health
	health.currentHealth = health.totalHealth
	
	# Set Enemy hue
	spr.color = enemyData.EnemyTable[enemyKey].color
	
	return inst
	
# Only runs once everything is loaded
func _on_battle_ready():
	#var enemyNum = generateNumOfEnemies()	# Determine number of enemies in battle
	#placeEnemies(enemyNum)
	pass # Replace with function body.

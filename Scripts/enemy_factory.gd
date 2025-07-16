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
var enemyLabelScene = preload("res://Scenes/entity_label.tscn")
var enemyData = preload("res://Data/EnemyData.tres")


# Constants
var rng = RandomNumberGenerator.new()


const ENTITY_Y_OFFSET : int = 180
const ENTITY_Y_SPACING : int = 200			# Multiplied by position to evenly space all enemies
const ENTITY_X_OFFSET : int = -150
const LABEL_Y_OFFSET : int = 5

#NOTE: onready wouldn't show up in time for setPosition, causing enemies to spawn off the screen. Current fix is to instead get the view width withing setPosition
var VIEW_WIDTH : int

var BATTLE		# Root Battle node. Houses variables within the scope of the whole scene. Needs to be assigned after Battle has been initialized

func _init():
	SignalBus.connect("playerInitComplete", createEnemies)

func _ready():
	pass



# Main function that serves as a jumping off point for everything else. 
func createEnemies(lastPlayerPos : int):
	BATTLE = self.owner
	
	var enemyNum = generateNumOfEnemies()	# Determine number of enemies in battle
	placeEnemies(enemyNum, lastPlayerPos)
	SignalBus.enemyInitComplete.emit(BATTLE.startingEnemies)
	#SignalBus.battleInitComplete.emit(playerEntites, startingEnemies)
	SignalBus.battleInitComplete.emit()
	
# Generate number of enemies
func generateNumOfEnemies() -> int: 
	return rng.randi_range(1,3)

# Cycle through enemy positions to generate a random enemy from the dictionary list of all enemies, then instantiate
func placeEnemies(enemyNum : int, lastPlayerPos : int):
	
	for i in range(enemyNum):
		# Create Enemy
		var enemyInst = createEnemy(i, lastPlayerPos)
		add_child(enemyInst)
		
		# Create Label
		var labelInst = createEnemyLabel(i, lastPlayerPos, enemyInst)
		add_child(labelInst)
		
		SignalBus.enemySpawned.emit(enemyInst, lastPlayerPos + i) # Goes to EnemiesList under UI
		
		#Add unique references to Enemies (Currently unused but maybe necessary later)
		BATTLE.startingEnemies.append(enemyInst)
		BATTLE.activeEnemies.append(enemyInst)	
	
	
func createEnemy(currentPos : int, lastPlayerPos : int) -> Variant:
	var enemyInst = enemyScene.instantiate()
	enemyInst = setPosition(enemyInst, currentPos, ENTITY_Y_SPACING, ENTITY_X_OFFSET, ENTITY_Y_OFFSET)
	enemyInst = generateEnemyType(enemyInst)		# Using EnemyData.tres/gd - will randomly generate a statblock from the enemy dictionary
	enemyInst.pos = lastPlayerPos + currentPos
	return enemyInst

func createEnemyLabel(currentPos : int, lastPlayerPos : int, enemyInst : Variant) -> Variant:
		var spr = enemyInst.get_child(Globals.enemyChildren.SPRITE)
		var stats = enemyInst.get_child(Globals.enemyChildren.STATS)
		var health = enemyInst.get_child(Globals.enemyChildren.HEALTH)
		
		var labelInst = enemyLabelScene.instantiate()
		labelInst = setPosition(
			labelInst, currentPos, 
			ENTITY_Y_SPACING, 
			ENTITY_X_OFFSET, ENTITY_Y_OFFSET + LABEL_Y_OFFSET
		)
		
		labelInst.pos = lastPlayerPos + currentPos
		labelInst.totalHealth = health.totalHealth
		labelInst.currentHealth = health.currentHealth
		labelInst.entityName = stats.eName
		
		return labelInst
		
# Sets the x and y value of the enemy
func setPosition(entity : Variant, pos : int, Y_SPACING : int, X_OFFSET : int,  Y_OFFSET : int ) -> Variant:
	VIEW_WIDTH = get_window().size[0] 	#NOTE: In the future this will be a global variable, but for right now it can stay here as the only thing that needs it.
	
	entity.position.y = (pos * Y_SPACING) + Y_OFFSET
	entity.position.x = VIEW_WIDTH + X_OFFSET
	return entity

# Uses dictionary from EnemyData to randomly select an enemy type - then instantiates
func generateEnemyType(inst : Variant) -> Variant:
	var keys = enemyData.EnemyTable.keys() 						# Get all keys in dictionary
	var enemyKey = keys[rng.randi_range(0, (keys.size()) -1)]	# Key for the specific enemy generated
	
	# Store Enemy Children
	var spr = inst.get_child(Globals.enemyChildren.SPRITE)
	var stats = inst.get_child(Globals.enemyChildren.STATS)
	var health = inst.get_child(Globals.enemyChildren.HEALTH)
	
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

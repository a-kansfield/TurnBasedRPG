extends Node2D

# Functions very similarly to enemy factory with a few differences. I could refactor much of this to share a factory class, however for now I'm settling for separate but similar nodes.
# Party Members should be an array instead of a dictionary - its easier to alter this way and there are less than there would be of enemies

# SPACING
const ENTITY_Y_OFFSET : int = 180
const ENTITY_Y_SPACING : int = 200			# Multiplied by position to evenly space all entities
const ENTITY_X_OFFSET : int = 550
const LABEL_Y_OFFSET : int = 5

const NUM_PARTY_MEMBERS : int = 3

var playerCharScene = preload("res://Scenes/player_char.tscn")
var entityLabelScene = preload("res://Scenes/entity_label.tscn")

@onready var VIEW_WIDTH : int = get_window().size[0]

var BATTLE
#var activeEntities : Array



func _ready():
	
	BATTLE = self.owner
	print("Root Node Array from Party Factory: ", BATTLE.activeEnemies)
	placePlayers()
	SignalBus.playerInitComplete.emit(NUM_PARTY_MEMBERS)
	
func placePlayers():
	
	for i in range(NUM_PARTY_MEMBERS):
		var entityInst = createPartyChar(i)
		add_child(entityInst)
		
		# Create Label
		var labelInst = createPartyLabel(i, entityInst)
		add_child(labelInst)

func createPartyChar(currentPos : int):
	var entityInst = playerCharScene.instantiate()
	entityInst.pos = currentPos
	entityInst = setPosition(entityInst, currentPos, ENTITY_Y_SPACING, ENTITY_X_OFFSET, ENTITY_Y_OFFSET)
	setStats(entityInst, currentPos)
	BATTLE.activePlayers.append(entityInst)
	
	
	return entityInst
	pass
	
func createPartyLabel(currentPos : int, entityInst : Variant) -> Variant:
	var labelInst = entityLabelScene.instantiate()
	var stats = entityInst.get_child(Globals.enemyChildren.STATS)
	var health = entityInst.get_child(Globals.enemyChildren.HEALTH)
	
	labelInst = setPosition(
		labelInst, currentPos, 
		ENTITY_Y_SPACING, 
		ENTITY_X_OFFSET, ENTITY_Y_OFFSET + LABEL_Y_OFFSET
	)
	
	labelInst.pos = currentPos
	labelInst.totalHealth = health.totalHealth
	labelInst.currentHealth = health.currentHealth
	labelInst.entityName = stats.eName
	
	return labelInst
	
func setPosition(entity : Variant, pos : int, Y_SPACING : int, X_OFFSET : int,  Y_OFFSET : int ) -> Variant:
	entity.position.y = (pos * Y_SPACING) + Y_OFFSET
	entity.position.x = X_OFFSET
	
	return entity


func setStats(inst : Variant, pos : int):
	var stats = inst.get_child(Globals.enemyChildren.STATS)
	var health = inst.get_child(Globals.enemyChildren.HEALTH)
	
	stats.eName = Globals.partyMembers[pos]["Name"]
	stats.dexterity = Globals.partyMembers[pos]["Dexterity"]
	stats.strength = Globals.partyMembers[pos]["Strength"]
	stats.health = Globals.partyMembers[pos]["Health"]
	
	health.totalHealth = stats.health
	health.currentHealth = stats.health
	pass

extends Node2D

var activeEnemies : Array
var activePlayers : Array

var activeEntity

func _init():
	SignalBus.battleInitComplete.connect(initializeBattleOrder)
	
func _ready():
	print("Hello from Turn Controller")
	
	
func initializeBattleOrder(activeEnemies):
		self.activeEnemies = activeEnemies
		
		print("Before Sort")
		for i in activeEnemies:
			print("================================================")
			print("Order: ", i.pos)
			print("Health: ", i.get_child(Constants.enemyChildren.STATS).health)
			print("Strength: ", i.get_child(Constants.enemyChildren.STATS).strength)
			print("Dexterity: ", i.get_child(Constants.enemyChildren.STATS).dexterity)
			print("================================================")
			
		calcTurnOrder(activeEnemies)
		
		print("After Sort")
		for i in activeEnemies:
			print("================================================")
			print("Order: ", i.pos)
			print("Health: ", i.get_child(Constants.enemyChildren.STATS).health)
			print("Strength: ", i.get_child(Constants.enemyChildren.STATS).strength)
			print("Dexterity: ", i.get_child(Constants.enemyChildren.STATS).dexterity)
			print("================================================")
			
func calcTurnOrder(activeCombatants : Array):
	activeCombatants.sort_custom(sortByDex)
	activeEntity = activeCombatants[0]

func sortByDex(ent1, ent2):
	var dex1 = ent1.get_child(Constants.enemyChildren.STATS).dexterity
	var dex2 = ent2.get_child(Constants.enemyChildren.STATS).dexterity
	if dex1 > dex2:
		return true
	else:
		return false
	#var stat1 = getStats(ent1)
	#var stat2 = getStats(ent2)
#
	#if stat1.getDexterity() > stat2.getDexterity():
		#return true
	#else:
		#return false
func changeActiveEnemies(newEnemyList : Array):
	pass
	
func advanceTurn():
	pass

extends Node2D

var activeEnemies : Array
var activePlayers : Array
var activeCombatants : Array
var activeEntity : Node2D
var turnOrder : int = 0;

func _init():
	SignalBus.battleInitComplete.connect(initializeBattleOrder)
	
func _ready():
	pass
	
	
func initializeBattleOrder(activeEnemies):
		self.activeEnemies = activeEnemies

		activeCombatants = calcTurnOrder(activeEnemies)
		activeEntity = activeCombatants[0]
		
		print("Combatants in Order")
		for i in activeEnemies:
			print("================================================")
			print("Order: ", i.pos)
			print("Health: ", i.get_child(Constants.enemyChildren.STATS).health)
			print("Strength: ", i.get_child(Constants.enemyChildren.STATS).strength)
			print("Dexterity: ", i.get_child(Constants.enemyChildren.STATS).dexterity)
			print("================================================\n\n")
			
		firstTurn()

# Note: Eventually add players, will require combining activePlayers and activeEnemies for activeCombatants
func calcTurnOrder(activeCombatants : Array):
	activeCombatants.sort_custom(sortByDex)
	
	return activeCombatants

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

func firstTurn():
	turnOrder = 0
	print("\nFirst Turn")
	print("================================================\n")
	print(activeEntity.get_child(Constants.enemyChildren.STATS).eName, "'s turn")
	print("In position ", activeEntity.pos)
	
	
func advanceTurn():

	turnOrder += 1
	if turnOrder > activeCombatants.size() - 1:
		print("\n\n================================================")
		print("New Round")
		print("================================================\n\n")
		turnOrder = 0
		
	activeEntity = activeCombatants[turnOrder]
	
	print("\nNext Turn")
	print("================================================\n")
	print(activeEntity.get_child(Constants.enemyChildren.STATS).eName, "'s turn")
	print("In position ", activeEntity.pos)

func _on_next_turn_btn_button_up():
	advanceTurn()
	pass # Replace with function body.

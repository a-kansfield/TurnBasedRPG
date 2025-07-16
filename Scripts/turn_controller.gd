extends Node2D

enum AFFILIATIONS {
	PLAYER,
	ENEMY
}

var activeEntity : Node2D
var turnOrderCounter : int = 0;
@onready var enemyTurnTimer = get_child(0) 
var BATTLE

# TODO: (Much later) Many RPGs let fast characters go multiple times before the enemy. Maybe if a character "laps" their opponents dex, they would go twice before they went once?
#		For example, a rouge with 12 dex would go twice before an enemy with 5 dex gets to go? I'd have to consider how best to do that. 
#		Maybe a check for if they 'lap' anyone, and then slot them in above the entity with the highest dex that they are still over double of? Keeping track of how many times they are lapping and looping it?
#		Alternatively, going down the list and subtracting the second fastest, then the third fastest until the dex reaches 0, then doing it for the second one in the array, then third.

func _init():
	
	SignalBus.battleVarsSet.connect(initializeBattleOrder)
	SignalBus.battleInitComplete.connect(initializeBattleOrder)
	SignalBus.entityDestroyed.connect(removeEntityFromTurnOrder)
	SignalBus.playerEndTurn.connect(endPlayerTurn)

	
func _ready():
	pass

	
func initializeBattleOrder():
	# Earliest bit of code run so the best place I can name the root node.
	# For some reason @onready doesn't proc in time, or even _init for reasons unknown. 
	# (Maybe self.owner wasn't instantiated at those earlier points?)
	BATTLE = self.owner
	
	# Load active battle entites
	BATTLE.activeCombatants = calcTurnOrder(BATTLE.activePlayers, BATTLE.activeEnemies)
	activeEntity = BATTLE.activeCombatants[0]
	
	#print("Combatants in Order")
	#for i in activeCombatants:
		#printCombatant(i)

	firstTurn()

#Both enemies and players, as they use the same child order for now - this is likely going to change, so I am hesitant to change it to entityChildren
func printCombatant(combatant : Variant):
	var stats = combatant.get_child(Globals.enemyChildren.STATS)
	var affiliation = "Unaffiliated"
	print(str(AFFILIATIONS.PLAYER))
	if combatant.is_in_group("battlePlayers"):
		affiliation = "Player"
	elif combatant.is_in_group("battleEnemies"):
		affiliation = "Enemy"
	
	print("================================================")
	print("NAME: ", stats.eName, " \t\t\t Affiliation: ", affiliation)
	print("================================================")
	print("HEALTH: ", stats.health, "\t\t\t\t\t\t", "DEX: ", stats.dexterity, "\tSTR:", stats.strength)
	print("================================================\n\n")
	
	
func calcTurnOrder(activePlayers : Array, activeEnemies : Array):
	var activeCombatants : Array
	# Combine players and enemies into one turn order
	activeCombatants.append_array(activePlayers)
	activeCombatants.append_array(activeEnemies)
	activeCombatants.sort_custom(sortByDex)
	
	return activeCombatants

func sortByDex(ent1, ent2):
	var dex1 = ent1.get_child(Globals.enemyChildren.STATS).dexterity
	var dex2 = ent2.get_child(Globals.enemyChildren.STATS).dexterity
	
	if dex1 > dex2:
		return true
	else:
		return false
		
func changeActiveEnemies(newEnemyList : Array):
	pass

func firstTurn():
	turnOrderCounter = 0
	determineAffiliation(activeEntity)
	print("\nFirst Turn")
	print("================================================\n")
	printCombatant(activeEntity)
	
	
func advanceTurn():

	turnOrderCounter += 1
	if turnOrderCounter > BATTLE.activeCombatants.size() - 1:
		print("\n\n================================================")
		print("New Round")
		print("================================================\n\n")
		turnOrderCounter = 0
		
	activeEntity = BATTLE.activeCombatants[turnOrderCounter]
	determineAffiliation(activeEntity)
	
	print("\nTurn ", turnOrderCounter)
	print("================================================\n")
	printCombatant(activeEntity)

func playerTurn(activeCombatant):
	SignalBus.playerTurn.emit(activeCombatant, BATTLE.activeEnemies)
	pass
	
func enemyTurn(activeCombatant):
	SignalBus.enemyTurn.emit(activeCombatant, BATTLE.activePlayers)
	
# Helper for first turn and advance turn. checks whether it is player or AI turn then sends out a signal accordingly
func determineAffiliation(activeCombatant : Variant):

	if activeCombatant.affiliation == "Enemy":
		enemyTurn(activeCombatant)
		enemyTurnTimer.start()
		
	elif activeCombatant.affiliation == "Player":
		playerTurn(activeCombatant)
	



# SIGNAL FUNCTIONS
func _on_next_turn_btn_button_up():
	advanceTurn()

# Theres a better way to do this than checking through 2 arrays for the same unique ID I'm sure...
func removeEntityFromTurnOrder(removedEntityPos):
	var removedCombatant
	var count = 0
	for i in BATTLE.activeCombatants:
		if i.pos == removedEntityPos:
			removedCombatant = BATTLE.activeCombatants.pop_at(count)
		count += 1
			
	if removedCombatant.affiliation == "Player":
		count = 0
		for i in BATTLE.activePlayers:
			if i.pos == removedEntityPos && removedCombatant != null:
				BATTLE.activePlayers.remove_at(count)
				print(BATTLE.activePlayers)
			count += 1
			if BATTLE.activePlayers.size() == 0:
				print("YOU DIED")
	elif removedCombatant.affiliation == "Enemy":
		count = 0
		for i in BATTLE.activeEnemies:
			if i.pos == removedEntityPos && removedCombatant != null:
				BATTLE.activeEnemies.remove_at(count)
			count += 1
			if BATTLE.activeEnemies.size() == 0:
				print("THEY DIED")


func endPlayerTurn():
	advanceTurn()

func _on_enemy_turn_timer_timeout():
	advanceTurn()
	pass # Replace with function body.

extends Node2D

enum AFFILIATIONS {
	PLAYER,
	ENEMY
}


var activeEnemies : Array
var activePlayers : Array
var activeCombatants : Array
var activeEntity : Node2D
var turnOrder : int = 0;



# TODO: (Much later) Many RPGs let fast characters go multiple times before the enemy. Maybe if a character "laps" their opponents dex, they would go twice before they went once?
#		For example, a rouge with 12 dex would go twice before an enemy with 5 dex gets to go? I'd have to consider how best to do that. 
#		Maybe a check for if they 'lap' anyone, and then slot them in above the entity with the highest dex that they are still over double of? Keeping track of how many times they are lapping and looping it?
#		Alternatively, going down the list and subtracting the second fastest, then the third fastest until the dex reaches 0, then doing it for the second one in the array, then third.

func _init():
	SignalBus.battleInitComplete.connect(initializeBattleOrder)

	
func _ready():
	pass

	
func initializeBattleOrder(activePlayers, activeEnemies):
	
	# Load active battle entites
	self.activeEnemies = activeEnemies
	self.activePlayers = activePlayers
	activeCombatants = calcTurnOrder(activePlayers, activeEnemies)
	activeEntity = activeCombatants[0]
	
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
	turnOrder = 0
	determineAffiliation(activeEntity)
	print("\nFirst Turn")
	print("================================================\n")
	printCombatant(activeEntity)
	
	
func advanceTurn():

	turnOrder += 1
	if turnOrder > activeCombatants.size() - 1:
		print("\n\n================================================")
		print("New Round")
		print("================================================\n\n")
		turnOrder = 0
		
	activeEntity = activeCombatants[turnOrder]
	determineAffiliation(activeEntity)
	
	print("\nTurn ", turnOrder)
	print("================================================\n")
	printCombatant(activeEntity)

func playerTurn(activeCombatant):
	SignalBus.playerTurn.emit(activeCombatant, activeEnemies)
	pass
	
func enemyTurn(activeCombatant):
	SignalBus.enemyTurn.emit(activeCombatant, activePlayers)
	
# Helper for first turn and advance turn. checks whether it is player or AI turn then sends out a signal accordingly
func determineAffiliation(activeCombatant : Variant):

	if activeCombatant.affiliation == "Enemy":
		enemyTurn(activeCombatant)
		
	elif activeCombatant.affiliation == "Player":
		playerTurn(activeCombatant)
	



# SIGNAL FUNCTIONS
func _on_next_turn_btn_button_up():
	advanceTurn()

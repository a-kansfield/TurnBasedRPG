extends Node2D

# Houses variables that exist within the scope of the battle. All references to battle entites will go through this node.

# Scene Vars
var startingEnemies : Array
var activeEnemies : Array
var activePlayers : Array
var activeCombatants : Array


func _init():
	SignalBus.battleInitComplete.connect(_battleInitComplete)
	SignalBus.playerInitComplete.connect(_playerInitComplete)
	SignalBus.enemyInitComplete.connect(_enemyInitComplete)
	
	pass


func _playerInitComplete(lastPos : int):
	print("Player Init Complete from Scene Root")
	
	pass
	
func _enemyInitComplete(startingEnemies : Array):
	self.activeEnemies = startingEnemies
	print("Enemy Init Complete from Scene Root")
	pass
	
func _battleInitComplete(a, b):
	print("Battle Init Complete from Scene Root")
	pass

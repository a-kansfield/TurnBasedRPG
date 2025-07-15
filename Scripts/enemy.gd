extends Node2D

var keyName : String = "Default"
var pos : int
var affiliation = "Enemy"

var rng = RandomNumberGenerator.new()

func _init():
	SignalBus.enemyTurn.connect(selectPlayerTarget)
	add_to_group("battleEnemies")
func _ready():
	SignalBus.entityDestroyed.connect(destroySelf)
	# Ok so apparently scene groups just refuse to work so we're gonna try global groups which is ass but ugh
	
	

func destroySelf(pos):
	if self.pos == pos:
		queue_free()

# Currently will select at random. More advanced AI can be added later
func selectPlayerTarget(enemy : Variant, playerEntities : Array):
	var selectedTarget = null
	var targetNode = null
	var enemyStats = null
	
	if self.pos == enemy.pos:
		selectedTarget = rng.randi_range(0, playerEntities.size() - 1)
		targetNode =  playerEntities[selectedTarget]
		enemyStats = enemy.get_child(Globals.enemyChildren.STATS)
		
		print("Selected Target: ", playerEntities[selectedTarget].get_child(Globals.enemyChildren.STATS).eName)
		
		SignalBus.changeEntityHealth.emit(targetNode.pos, -enemyStats.strength)
		#return playerEntities[selectedTarget]
	
	
	
	
	
	
	
	
	
# Unused - with a random number generator it can modulate the sprite color
#func randomColorGen(rng : RandomNumberGenerator):
	#var r = rng.randi_range(0, 255)
	#var g = rng.randi_range(0, 255)
	#var b = rng.randi_range(0, 255)
	#self.color = Color.from_rgba8(r,g,b,255)
	#modulate = color

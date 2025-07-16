extends Node2D

var keyName : String = "Default"
var pos : int
var affiliation = "Enemy"

var rng = RandomNumberGenerator.new()


# TEMP VARS - Used so I don't have to bring those values to the animation player only for it to bring it right back in its signal.
var tempTargetNodePos
var tempEnemyAttackVal

func _init():
	SignalBus.enemyTurn.connect(selectPlayerTarget)
	add_to_group("battleEnemies")
	
func _ready():
	get_child(Globals.enemyChildren.ANIM).play("RESET")
	SignalBus.entityDestroyed.connect(destroySelf)
	

func destroySelf(pos):
	if self.pos == pos:
		queue_free()

# Currently will select at random. More advanced AI can be added later. Health is not changed until the animation is complete.
func selectPlayerTarget(enemy : Variant, playerEntities : Array):
	var selectedTarget = null
	var targetNode = null
	var enemyStats = null
	
	if self.pos == enemy.pos:
		selectedTarget = rng.randi_range(0, playerEntities.size() - 1)
		targetNode =  playerEntities[selectedTarget]
		enemyStats = enemy.get_child(Globals.enemyChildren.STATS)
		
		print("Selected Target: ", playerEntities[selectedTarget].get_child(Globals.enemyChildren.STATS).eName)
		tempTargetNodePos = targetNode.pos
		tempEnemyAttackVal = -enemyStats.strength
		
		self.get_child(Globals.enemyChildren.ANIM).play("attack_left")
		
		#return playerEntities[selectedTarget]
	
	
	
	
	
	
	
	
	
# Unused - with a random number generator it can modulate the sprite color
#func randomColorGen(rng : RandomNumberGenerator):
	#var r = rng.randi_range(0, 255)
	#var g = rng.randi_range(0, 255)
	#var b = rng.randi_range(0, 255)
	#self.color = Color.from_rgba8(r,g,b,255)
	#modulate = color


func landHit():
	print("Hit Landed")
	SignalBus.changeEntityHealth.emit(tempTargetNodePos, tempEnemyAttackVal)
	
	pass # Replace with function body.

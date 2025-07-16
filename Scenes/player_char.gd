extends Node2D

var pos : int
var affiliation = "Player"

var tempAttackStr : int = -1
var tempActivePlayerPos : int = -1
var tempTargetEnemyPos : int = -1

@onready var animationPlayer = get_child(Globals.enemyChildren.ANIM)
@onready var stats = get_child(Globals.enemyChildren.STATS)

func _init():
	add_to_group("battlePlayers")
	SignalBus.playerTurn.connect(playerTurnSetup)
	SignalBus.playerAttack.connect(handlePlayerTarget)
	SignalBus.entityDestroyed.connect(destroySelf)
	
func destroySelf(pos):
	if self.pos == pos:
		queue_free()

func playerTurnSetup(activeEntity : Variant, targetEnemies : Array):
	self.tempActivePlayerPos = activeEntity.pos
	if activeEntity.pos == pos:
		self.tempAttackStr = activeEntity.get_child(Globals.enemyChildren.STATS).strength
	
func handlePlayerTarget(targetEnemyPos):
	if self.pos == tempActivePlayerPos:
		self.tempTargetEnemyPos = targetEnemyPos
		animationPlayer.play("attack_right")

		
func landHit():
	print("Hit Landed")
	SignalBus.changeEntityHealth.emit(tempTargetEnemyPos, -tempAttackStr)
	get_node("Timer").start()
	pass


func _on_timer_timeout():
	SignalBus.playerEndTurn.emit()
	pass # Replace with function body.

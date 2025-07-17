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
	Battle_SB.playerTurn.connect(playerTurnSetup)
	Battle_SB.playerAttack.connect(handlePlayerTarget)
	Battle_SB.entityDestroyed.connect(destroySelf)
	
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
	Battle_SB.changeEntityHealth.emit(tempTargetEnemyPos, -tempAttackStr)
	get_node("Timer").start()
	pass


func _on_timer_timeout():
	Battle_SB.playerEndTurn.emit()
	pass # Replace with function body.

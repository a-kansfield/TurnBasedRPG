extends Label

var formatString = "%s's Turn"
var BATTLE

func _init():
	Battle_SB.playerTurn.connect(setTurnText)
	Battle_SB.enemyTurn.connect(setTurnText)
	pass
	

func setTurnText(entity : Variant, activeEntities: Array):
	self.text = formatString % entity.get_child(Globals.enemyChildren.STATS).eName
	pass

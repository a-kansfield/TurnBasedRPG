extends Control

func _init():
	#Experimenting with lambda functions to "eat" unnecessary params
	SignalBus.enemyTurn.connect(func(a,b): toggleMenuVisibility(a))
	SignalBus.playerTurn.connect(func(a,b): toggleMenuVisibility(a))
	
func toggleMenuVisibility(activeEntity):
	if activeEntity.affiliation == "Player":
		self.visible = true
	if activeEntity.affiliation == "Enemy":
		self.visible = false

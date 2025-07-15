extends Node2D

var totalHealth : int
var currentHealth : int

@onready var parent = get_parent()

func _ready():
	SignalBus.changeEntityHealth.connect(changeHealth)
	
# Called via Signal. This function works for both attacking and healing. An attack should include a negative number, and a heal should include a positive one.
func changeHealth(pos: int, amount : int):
	if parent.pos == pos:
		currentHealth = currentHealth + amount
		if currentHealth > totalHealth:
			currentHealth = totalHealth
		if currentHealth <= 0:
			currentHealth = 0
			# Destroy parent
			SignalBus.entityDestroyed.emit(get_parent().pos)
		else:
			SignalBus.projectCurrentHealth.emit(pos, currentHealth)

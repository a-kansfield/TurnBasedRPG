extends Node2D

var totalHealth : int
var currentHealth : int

@onready var parent = get_parent()

var healthChangeAnimScene = preload("res://Scenes/Battle/BattleEntity/health_change_anim.tscn")

func _ready():
	Battle_SB.changeEntityHealth.connect(changeHealth)
	
# Called via Signal. This function works for both attacking and healing. An attack should include a negative number, and a heal should include a positive one.
func changeHealth(pos: int, amount : int):
	if parent.pos == pos:
		currentHealth = currentHealth + amount
		if currentHealth > totalHealth:
			currentHealth = totalHealth
			
		if currentHealth <= 0:
			currentHealth = 0
			# Destroy parent
			Battle_SB.entityDestroyed.emit(get_parent().pos)
		else:
			healthAnimation(amount)
			
			Battle_SB.projectCurrentHealth.emit(pos, currentHealth)

func healthAnimation(amount : int):
	var inst = healthChangeAnimScene.instantiate()
	var label = inst.get_child(0)
	
	label.text = str(amount)
	add_child(inst)

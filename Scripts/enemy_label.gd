extends Control

# TODO: Spawn a label below each enemy
	# Pass location and info
var pos : int
var totalHealth : int
var currentHealth : int
var entityName : String

@onready var nameLabel = $PanelContainer/MarginContainer/LabelContainer/EnemyName
@onready var currentHealthLabel = $PanelContainer/MarginContainer/LabelContainer/CurrentHealth
@onready var totalHealthLabel = $PanelContainer/MarginContainer/LabelContainer/TotalHealth

func _ready():
	SignalBus.entityDestroyed.connect(destroySelf)
	nameLabel.text = entityName
	currentHealthLabel.pos = pos
	currentHealthLabel.text = str(currentHealth)
	totalHealthLabel.text = str(totalHealth)
	
func destroySelf(pos):
	if self.pos == pos:
		queue_free()

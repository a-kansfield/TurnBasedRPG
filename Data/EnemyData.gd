extends Resource
class_name EnemyData

var EnemyTable = {
	"rat" : {
		"name" : "Rat",
		"health" : 40,
		"strength" : 4,
		"dexterity": 2,
		"color" : Color.from_rgba8(40,20,60,255)
	},
	"slime" : {
		"name" : "Slime",
		"health" : 20,
		"strength" : 6,
		"dexterity": 5,
		"color" : Color.from_rgba8(80,210,180,255)
	},
	"plant" : {
		"name" : "A Literal Shrub",
		"health" : 5,
		"strength" : 2,
		"dexterity": 8,
		"color" : Color.from_rgba8(120,180,100,255)
	}
	
}

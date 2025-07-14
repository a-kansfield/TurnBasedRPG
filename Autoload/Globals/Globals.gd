extends Node

enum enemyChildren {
	SPRITE = 0, 
	STATS = 1, 
	HEALTH = 2
}	# Note: Adjust as children are added to Enemy.tscn


# All party members, first 3 are active in combat.
var partyMembers = [
	{
		"Name": "Main Character",
		"Strength": 8,
		"Dexterity": 6,
		"Health": 90
	},
	{
		"Name": "Character 2",
		"Strength": 12,
		"Dexterity": 3,
		"Health": 120
	},
	{
		"Name": "Character 3",
		"Strength": 3,
		"Dexterity": 12,
		"Health": 60
	},
]

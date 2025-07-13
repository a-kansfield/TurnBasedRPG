extends Node

var enemyData = preload("res://Data/EnemyData.tres")

signal attackEnemy

signal enemySpawned(inst, pos, enemyChildren) #inst, pos, enemyChildren
signal battleInitComplete(activeEnemies)


signal entityDestroyed(charPos : int)
signal changeEntityHealth(charPos : int, amount : int)

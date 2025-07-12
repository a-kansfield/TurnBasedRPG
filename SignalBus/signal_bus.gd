extends Node

var enemyData = preload("res://Data/EnemyData.tres")

signal attackEnemy
signal enemyDestroyed(enemyPos : int)
signal enemySpawned(inst, pos, enemyChildren) #inst, pos, enemyChildren
signal battleInitComplete(activeEnemies)

extends Node

var enemyData = preload("res://Data/EnemyData.tres")

signal attackEnemy

signal enemySpawned(inst, pos) #inst, pos, enemyChildren

signal playerInitComplete(lastPos : int, loadedPlayers : Array)
signal battleInitComplete(playerEntites : Array, activeEnemies : Array)


signal entityDestroyed(charPos : int)
signal changeEntityHealth(charPos : int, amount : int)

signal projectCurrentHealth(charPos: int, currentHealth : int)

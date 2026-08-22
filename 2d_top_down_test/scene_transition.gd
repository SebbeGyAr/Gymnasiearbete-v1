extends Node

var nextSpawnPoint: String = ""

func change_scene(scenePath, spawnPoint) -> void:
	print("Setting spawn point to: ", spawnPoint)
	nextSpawnPoint = spawnPoint
	get_tree().change_scene_to_file(scenePath)

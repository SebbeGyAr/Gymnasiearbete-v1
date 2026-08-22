extends Node

var nextSpawnPoint: String = ""

func change_scene(scenePath: String, spawnPoint: String) -> void:
	nextSpawnPoint = spawnPoint
	get_tree().change_scene_to_file(scenePath)

extends Area2D



func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter": 
		SceneTransition.change_scene("res://scenes/Levels/game_level.tscn", "HouseExitSpawn")

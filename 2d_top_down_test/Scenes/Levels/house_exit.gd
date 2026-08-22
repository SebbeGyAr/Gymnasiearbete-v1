extends Area2D



func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter": 
		get_tree().change_scene_to_file("res://scenes/Levels/game_level.tscn")

extends Node2D


func _ready() -> void:
	$PlayerCharacter/Camera2D.zoom = Vector2(5, 5)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"): 
		get_tree().change_scene_to_file("res://scenes/UI/menus/main_menu.tscn")
	

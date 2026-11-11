extends CanvasLayer

@onready var player = $".."

func _on_resume_pressed() -> void:
	player.pause_menu()

func _on_save_pressed() -> void:
	$MarginContainer/VBoxContainer/Save.text = "This does nothing right now"
	await get_tree().create_timer(1).timeout
	$MarginContainer/VBoxContainer/Save.text = "Save"


func _on_quit_main_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/Menus/main_menu.tscn")


func _on_quit_desktop_pressed() -> void:
	$MarginContainer/VBoxContainer/QuitDesktop.text = "Quitting Game "
	get_tree().paused = false
	await get_tree().create_timer(0.1).timeout
	$MarginContainer/VBoxContainer/QuitDesktop.text = "Quitting Game. "
	await get_tree().create_timer(0.1).timeout
	$MarginContainer/VBoxContainer/QuitDesktop.text = "Quitting Game.. "
	await get_tree().create_timer(0.1).timeout
	$MarginContainer/VBoxContainer/QuitDesktop.text = "Quitting Game... "
	await get_tree().create_timer(0.1).timeout

	get_tree().quit()

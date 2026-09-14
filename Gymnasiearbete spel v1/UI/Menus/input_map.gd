extends Control


func _ready() -> void:
	# STARTAR MUSIKEN DÄR DEN SENAST SPARADES
	$AudioStreamPlayer.play(GlobalVariables.musicProgress)
	AudioServer.set_bus_volume_db(0, GlobalVariables.soundSlider)


func _process(_delta: float) -> void:
	# SPARAR VAR MUSIKEN ÄR OCH GÅR TILLBAKA TILL MAIN MENU NÄR MAN TRYCKER PÅ ESCAPE
	if Input.is_action_just_released("ui_cancel"):
		GlobalVariables.musicProgress = $AudioStreamPlayer.get_playback_position()
		get_tree().change_scene_to_file("res://UI/Menus/main_menu.tscn")


func _on_back_button_pressed() -> void:
	# SPARAR VAR MUSIKEN ÄR OCH GÅR TILLBAKA TILL MAIN MENU NÄR MAN TRYCKER PÅ BACK KNAPPEN
	GlobalVariables.musicProgress = $AudioStreamPlayer.get_playback_position()
	get_tree().change_scene_to_file("res://UI/Menus/main_menu.tscn")

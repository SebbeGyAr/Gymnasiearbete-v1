extends Control


@onready var buttonsVBox = $MarginContainer/VBoxContainer/ButtonsVBox

func _ready() -> void:
	# STARTAR MENYMUSIK SÅ FORT MAN KOMMER IN I SPELET
	$AudioStreamPlayer.play(GlobalVariables.musicProgress)
	AudioServer.set_bus_volume_db(0, GlobalVariables.soundSlider)

func _process(_delta: float) -> void:
	# STÄNGER SPELET EFTER 0,4 SEKUNDER OM ESCAPE TRYCKS NED
	if Input.is_action_just_pressed("ui_cancel"):
		$MarginContainer/VBoxContainer/ButtonsVBox/QuitGameButton.text = "Quitting Game"
		await get_tree().create_timer(0.1).timeout
		$MarginContainer/VBoxContainer/ButtonsVBox/QuitGameButton.text = "Quitting Game."
		await get_tree().create_timer(0.1).timeout
		$MarginContainer/VBoxContainer/ButtonsVBox/QuitGameButton.text = "Quitting Game.."
		await get_tree().create_timer(0.1).timeout
		$MarginContainer/VBoxContainer/ButtonsVBox/QuitGameButton.text = "Quitting Game..."
		await get_tree().create_timer(0.1).timeout
		
		get_tree().quit()

func _on_start_game_button_pressed() -> void:
	# BYTER SCEN TILL HUVUDSCENEN EFTER 0,4 SEKUNDER (LITEN "TEXTANIMATION")
	$MarginContainer/VBoxContainer/ButtonsVBox/StartGameButton.text = "Starting Game"
	await get_tree().create_timer(0.1).timeout
	$MarginContainer/VBoxContainer/ButtonsVBox/StartGameButton.text = "Starting Game."
	await get_tree().create_timer(0.1).timeout
	$MarginContainer/VBoxContainer/ButtonsVBox/StartGameButton.text = "Starting Game.."
	await get_tree().create_timer(0.1).timeout
	$MarginContainer/VBoxContainer/ButtonsVBox/StartGameButton.text = "Starting Game..."
	await get_tree().create_timer(0.1).timeout
	
	get_tree().change_scene_to_file("res://Scenes/main_map.tscn")
	
func _on_quit_game_button_pressed() -> void:
	# STÄNGER SPELET OM QUIT-KNAPPEN TRYCKS NED EFTER 0,4 SEKUNDER (LITEN "TEXTANIMATION")
	$MarginContainer/VBoxContainer/ButtonsVBox/QuitGameButton.text = "Quitting Game"
	await get_tree().create_timer(0.1).timeout
	$MarginContainer/VBoxContainer/ButtonsVBox/QuitGameButton.text = "Quitting Game."
	await get_tree().create_timer(0.1).timeout
	$MarginContainer/VBoxContainer/ButtonsVBox/QuitGameButton.text = "Quitting Game.."
	await get_tree().create_timer(0.1).timeout
	$MarginContainer/VBoxContainer/ButtonsVBox/QuitGameButton.text = "Quitting Game..."
	await get_tree().create_timer(0.1).timeout

	get_tree().quit()

func _on_options_button_pressed() -> void:
	# BYTER TILL OPTIONS SCENEN EFTER ATT HA SPARAT VAR MUSIKEN ÄR
	GlobalVariables.musicProgress = $AudioStreamPlayer.get_playback_position()
	get_tree().change_scene_to_file("res://UI/Menus/options.tscn")
	

func _on_input_map_button_pressed() -> void:
	# SPARAR VAR MUSIKEN ÄR OCH BYTER SCEN TILL INPUT MAP SCENEN
	GlobalVariables.musicProgress = $AudioStreamPlayer.get_playback_position()
	get_tree().change_scene_to_file("res://UI/Menus/input_map.tscn")

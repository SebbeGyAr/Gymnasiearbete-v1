extends Control


@onready var buttonsVBox = $MarginContainer/VBoxContainer/ButtonsVBox

func _ready() -> void:
	# STARTAR MENYMUSIK SÅ FORT MAN KOMMER IN I SPELET
	if GlobalVariables.gameJustStarted: 
		$AudioStreamPlayer.volume_db = -80
		var audioTween = create_tween()
		audioTween.set_trans(Tween.TRANS_LINEAR)
		audioTween.tween_property($AudioStreamPlayer, "volume_db", -50, 1)
		GlobalVariables.gameJustStarted = false
	
	$AudioStreamPlayer.play(GlobalVariables.musicProgress)
	AudioServer.set_bus_volume_db(0, GlobalVariables.soundSlider)
	preload("res://Scenes/Cutscenes/beginning_cutscene.tscn")

func _process(_delta: float) -> void:
	# STÄNGER SPELET EFTER 0,4 SEKUNDER OM ESCAPE TRYCKS NED
	if Input.is_action_just_pressed("ui_cancel"):
		_on_quit_game_button_pressed()

func _on_start_game_button_pressed() -> void:
	var audioTween = create_tween()
	audioTween.set_trans(Tween.TRANS_LINEAR)
	audioTween.tween_property($AudioStreamPlayer, "volume_db", -100, 0.4)
	
	var videoTween = create_tween()
	videoTween.set_trans(Tween.TRANS_LINEAR)
	videoTween.tween_property($Panel, "modulate", Color(0.0, 0.0, 0.0, 1.0), 0.4)

	$MarginContainer/VBoxContainer/ButtonsVBox/StartGameButton.text = "Starting Game"
	await get_tree().create_timer(0.1).timeout
	$MarginContainer/VBoxContainer/ButtonsVBox/StartGameButton.text = "Starting Game."
	await get_tree().create_timer(0.1).timeout
	$MarginContainer/VBoxContainer/ButtonsVBox/StartGameButton.text = "Starting Game.."
	await get_tree().create_timer(0.1).timeout
	$MarginContainer/VBoxContainer/ButtonsVBox/StartGameButton.text = "Starting Game..."
	await get_tree().create_timer(0.1).timeout
	change_scene()
	
func _on_quit_game_button_pressed() -> void:
	var audioTween = create_tween()
	audioTween.set_trans(Tween.TRANS_LINEAR)
	audioTween.tween_property($AudioStreamPlayer, "volume_db", -100, 0.4)
	
	var videoTween = create_tween()
	videoTween.set_trans(Tween.TRANS_LINEAR)
	videoTween.tween_property($Panel, "modulate", Color(0.0, 0.0, 0.0, 1.0), 0.4)
	
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


func change_scene():
	get_tree().change_scene_to_file("res://Scenes/Cutscenes/beginning_cutscene.tscn")

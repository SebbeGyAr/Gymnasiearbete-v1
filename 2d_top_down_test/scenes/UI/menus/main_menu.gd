extends Control


signal startGame()

@onready var buttonsVBox = $MarginContainer/VBoxContainer/ButtonsVBox

func _ready() -> void:
	$AudioStreamPlayer.play(GlobalVariables.musicProgress)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		$MarginContainer/VBoxContainer/ButtonsVBox/QuitGameButton.text = "Quitting Game..."
		await get_tree().create_timer(0.4).timeout
		get_tree().quit()

func _on_start_game_button_pressed() -> void:
	# SKICKAR STARTSIGNAL NÄR KNAPP TRYCKS PÅ EFTER 0,4 SEK, BYTER TILL HUVUDSCENEN
	startGame.emit()
	$MarginContainer/VBoxContainer/ButtonsVBox/StartGameButton.text = "Starting Game..."
	await get_tree().create_timer(0.4).timeout
	get_tree().change_scene_to_file("res://scenes/Levels/game_level.tscn")
	
func _on_quit_game_button_pressed() -> void:
	# SKICKAR EN SNABB QUIT-SIGNAL EFTER 0,4 SEK
	$MarginContainer/VBoxContainer/ButtonsVBox/QuitGameButton.text = "Quitting Game..."
	await get_tree().create_timer(0.4).timeout
	get_tree().quit()
	
func _on_options_button_pressed() -> void:
	GlobalVariables.musicProgress = $AudioStreamPlayer.get_playback_position()
	get_tree().change_scene_to_file("res://scenes/UI/Menus/options.tscn")
	
func _on_visibility_changed() -> void:
	if visible: 
		focus_button()


func focus_button() -> void:
	if buttonsVBox:
		var button: Button = buttonsVBox.get_child(0)
		if button is Button: 
			button.grab_focus()

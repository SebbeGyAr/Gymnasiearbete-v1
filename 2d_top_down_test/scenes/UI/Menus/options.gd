extends Control

var resolutions =[
	Vector2(3840,2160),
	Vector2(2560,1440),
	Vector2(1920,1080),
	Vector2(1280,720),
	Vector2(128, 72)
]

func _ready() -> void:
	$AudioStreamPlayer.play(GlobalVariables.musicProgress)
	$MarginContainer/VBoxContainer/SettingsVBox/MasterSoundSlider.value = GlobalVariables.musicSlider
	$MarginContainer/VBoxContainer/SettingsVBox/FullscreenButton.button_pressed = GlobalVariables.fullscreen
	$MarginContainer/VBoxContainer/SettingsVBox/ResolutionMenu.selected = GlobalVariables.resolutionSet
	$MarginContainer/VBoxContainer/SettingsVBox/FramerateLimitMenu.selected = GlobalVariables.framerateSet
	$MarginContainer/VBoxContainer/SettingsVBox/VSyncButton.button_pressed = GlobalVariables.vsync


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/UI/Menus/main_menu.tscn")
#	print(PopupMenu.)

func _on_master_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	if value == 0: 
		AudioServer.set_bus_mute(0, true)
	else: 
		AudioServer.set_bus_mute(0, false)
	GlobalVariables.musicSlider = value

func _on_back_button_pressed() -> void: 
	GlobalVariables.musicProgress = $AudioStreamPlayer.get_playback_position()
	get_tree().change_scene_to_file("res://scenes/UI/Menus/main_menu.tscn")


func _on_resolution_menu_item_selected(index: int) -> void:
	match index: 
		0: 
			GlobalVariables.resolutionSet = 0
			DisplayServer.window_set_size(resolutions[0])
		1: 
			GlobalVariables.resolutionSet = 1
			DisplayServer.window_set_size(resolutions[1])
		2: 
			GlobalVariables.resolutionSet = 2
			DisplayServer.window_set_size(resolutions[2])
		3: 
			GlobalVariables.resolutionSet = 3
			DisplayServer.window_set_size(resolutions[3])
		4: 
			GlobalVariables.resolutionSet = 4
			DisplayServer.window_set_size(resolutions[4])


func _on_framerate_limit_menu_item_selected(index: int) -> void:
	match index: 
		0: 
			GlobalVariables.framerateSet = 0
			Engine.max_fps = 240
		1: 
			GlobalVariables.framerateSet = 1
			Engine.max_fps = 165
		2: 
			GlobalVariables.framerateSet = 2
			Engine.max_fps = 144
		3: 
			GlobalVariables.framerateSet = 3
			Engine.max_fps = 120
		4: 
			GlobalVariables.framerateSet = 4
			Engine.max_fps = 75
		5: 
			GlobalVariables.framerateSet = 5
			Engine.max_fps = 60
		6: 
			GlobalVariables.framerateSet = 6
			Engine.max_fps = 30
		7: 
			GlobalVariables.framerateSet = 7
			Engine.max_fps = 5


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		$MarginContainer/VBoxContainer/SettingsVBox/ResolutionMenu.disabled = true
		GlobalVariables.fullscreen = true
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		$MarginContainer/VBoxContainer/SettingsVBox/ResolutionMenu.disabled = false
		GlobalVariables.fullscreen = false


func _on_v_sync_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		GlobalVariables.vsync = true

	else: 
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		GlobalVariables.vsync = false

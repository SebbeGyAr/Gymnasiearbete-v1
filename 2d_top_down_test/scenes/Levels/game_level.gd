extends Node2D


var resolutions =[
	Vector2(3840,2160),
	Vector2(2560,1440),
	Vector2(1920,1080),
	Vector2(1280,720)
]

# KANSKE LÖSER SCREEN TEARING, GHOSTING OCH INPUT LAG VID 30 IFALL DET DYKER UPP VID HÖGRE
@export var maxFPS = 240
@export var player = Node2D
@onready var camera = $PlayerCharacter/Camera2D

var i = 0

func _ready() -> void:
	Engine.max_fps = maxFPS
	var spawnName = SceneTransition.nextSpawnPoint
	if spawnName != "":
		var spawn_node = find_child(spawnName, true, false)
		if spawn_node:
			player.global_position = spawn_node.global_position


func _physics_process(delta: float) -> void:
	var inputDirection = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	#print($PlayerCharacter.get_screen_transform()[2])
	
	#print(DisplayServer.window_get_size())
	
	if Input.is_action_just_pressed("ui_cancel"): 
		get_tree().change_scene_to_file("res://scenes/UI/menus/main_menu.tscn")

	if Input.is_action_just_pressed("ui_accept"): 
		if i < 3: i += 1
		else: i = 0
	var smoothSpeed = 2.0
	var targetOffset = Vector2.ZERO
	var targetDistance = 25
	


	if inputDirection.x > 0:
		targetOffset.x = 2 * targetDistance
	elif inputDirection.x < 0:
		targetOffset.x = -2 * targetDistance

	if inputDirection.y > 0:
		targetOffset.y = targetDistance
	elif inputDirection.y < 0:
		targetOffset.y = -targetDistance


	var t = 1.0 - exp(-smoothSpeed * delta)
	camera.offset = camera.offset.lerp(targetOffset, t)

extends Node2D

#var Cow = preload("res://scenes/Non Character Entities/cow.tscn")
@onready var player = $Player
@onready var camera = $Player/Camera2D
@onready var sprite2D = $Player/Sprite2D
var muzzleFlip = false

func _ready() -> void:
#	var spawnName = SceneTransition.nextSpawnPoint
#	if spawnName != "":
#		var spawn_node = find_child(spawnName, true, false)
#		if spawn_node:
#			player.global_position = spawn_node.global_position
	camera.zoom = Vector2(5, 5)
#	$UI/GunMagNode/BulletCounterLabel.text = "Bullets Left: %s/5" %GlobalVariables.bulletsLeft

func move_muzzle(arg):
	if arg == true and $Player/Muzzle.position.x > 0:
		$Player/Muzzle.position.x *= -1
	elif arg == false and $Player/Muzzle.position.x < 0:
		$Player/Muzzle.position.x *= -1
func _physics_process(delta: float) -> void:
	var inputDirection = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	#print($PlayerCharacter.get_screen_transform()[2])

	#print(DisplayServer.window_get_size())

	if Input.is_action_just_pressed("ui_cancel"): 
		get_tree().change_scene_to_file("res://UI/Menus/main_menu.tscn")
	
	
	var smoothSpeed = 1.0
	var targetOffset = Vector2.ZERO
	var targetDistance = 25
	
	
	if inputDirection.x > 0:
		targetOffset.x = 2 * targetDistance
		sprite2D.flip_h = false
		muzzleFlip = false
	elif inputDirection.x < 0:
		targetOffset.x = -2 * targetDistance
		sprite2D.flip_h = true
		muzzleFlip = true
	if inputDirection.y > 0:
		targetOffset.y = targetDistance
	elif inputDirection.y < 0:
		targetOffset.y = -targetDistance

	var t = 1.0 - exp(-smoothSpeed * delta)
	camera.offset = camera.offset.lerp(targetOffset, t)
	move_muzzle(muzzleFlip)

extends Node2D

#var Cow = preload("res://scenes/Non Character Entities/cow.tscn")
@onready var player = $Player
@onready var camera = $Player/Camera2D
@onready var sprite2D = $Player/Sprite2D
var muzzleFlip = false
var flashlightOffsetX = 7.0

func _ready() -> void:
#	var spawnName = SceneTransition.nextSpawnPoint
#	if spawnName != "":
#		var spawn_node = find_child(spawnName, true, false)
#		if spawn_node:
#			player.global_position = spawn_node.global_position
	camera.zoom = Vector2(5, 5)
#	$UI/GunMagNode/BulletCounterLabel.text = "Bullets Left: %s/5" %GlobalVariables.bulletsLeft

func move_muzzle(arg, t):
	if arg == true and $Player/Muzzle.position.x > 0:
		$Player/Muzzle.position.x *= -1
	
	elif arg == false and $Player/Muzzle.position.x < 0:
		$Player/Muzzle.position.x *= -1
	var targetX = -flashlightOffsetX if arg else flashlightOffsetX
	$Player/FlashlightNode.position.x = lerp($Player/FlashlightNode.position.x, targetX, t * 2)

func fade_alpha(target_alpha: float, duration: float):
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color:a", target_alpha, duration)
	
func _physics_process(delta: float) -> void:
	var smoothSpeed = 1.0
	var t = 1.0 - exp(-smoothSpeed * delta)
	var targetOffset = Vector2.ZERO
	var targetDistance = 25
	var inputDirection = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	
	if Input.is_action_just_pressed("ui_cancel"): 
		get_tree().change_scene_to_file("res://UI/Menus/main_menu.tscn")
	
	if Input.get_action_strength("down") - Input.get_action_strength("up") > 0:
		$Player/FlashlightNode.position.y = lerp($Player/FlashlightNode.position.y, 23.0, t * 2)
	elif Input.get_action_strength("down") - Input.get_action_strength("up") < 0:
		$Player/FlashlightNode.position.y = lerp($Player/FlashlightNode.position.y, -23.0, t * 2)
	else: $Player/FlashlightNode.position.y = lerp($Player/FlashlightNode.position.y, 0.0, t * 2)

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

	camera.offset = camera.offset.lerp(targetOffset, t)
	move_muzzle(muzzleFlip, t)

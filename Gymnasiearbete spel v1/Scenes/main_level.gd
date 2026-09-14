extends Node2D

# REMNANT FRÅN TESTSPELET
#var Cow = preload("res://scenes/Non Character Entities/cow.tscn")
@onready var player = $Player
@onready var camera = $Player/Camera2D
@onready var sprite2D = $Player/Sprite2D
@onready var flashlight = $Player/FlashlightPivot/FlashlightSprite
var muzzleFlip = false
var flashlightOffsetX = 7.0
var facingLeft = false

func _ready() -> void:
	# HAR ANVÄNTS FÖR ATT SPAWNA SPELAREN UTANFÖR HUSET I TESTSPELET, BEHÅLLER ÅT FRAMTIDA HUS
#	var spawnName = SceneTransition.nextSpawnPoint
#	if spawnName != "":
#		var spawn_node = find_child(spawnName, true, false)
#		if spawn_node:
#			player.global_position = spawn_node.global_position

	# SÄTTER CAMERA-ZOOM, OM DET INTE VAR TYDLIGT NOG
	camera.zoom = Vector2(5, 5)


func move_muzzle(arg, t):
	# OM INTE facingLeft OCH arg ÖVERENSSTÄMMER, SÄTT DEM TILL SAMMA OCH FLYTTA PÅ Muzzle OCH PIVOTA FLASHLIGHT-SPRITEN RUNT FlashlightPivot
	if arg != facingLeft:
		facingLeft = arg
		$Player/Muzzle.position.x *= -1
		$Player/FlashlightPivot.scale.x *= -1
	
	# OM move_muzzle SKICKATS MED arg = true AKA SKA FLYTTAS PÅ SÅ FLYTTA FLASHLIGHTNODE MOT ANDRA SIDAN AV SPELAREN MHA LERP (<3 LERP)
	var targetX = -flashlightOffsetX if arg else flashlightOffsetX
	$Player/FlashlightNode.position.x = lerp($Player/FlashlightNode.position.x, targetX, t * 2)

# KSK GÖR NÅGOT MED I FRAMTIDEN, FÖR ATT FADEA SKYMNING OCH EVENTUELL DIMMA ELLER LIKNANDE
"""func fade_alpha(target_alpha: float, duration: float):
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color:a", target_alpha, duration)
	"""


func _physics_process(delta: float) -> void:
	# VARIABLER ÅT KAMERARÖRELSE, SJÄLVFÖRKLARANDE
	var smoothSpeed = 1.0
	var t = 1.0 - exp(-smoothSpeed * delta)
	var targetOffset = Vector2.ZERO
	var targetDistance = 25
	var inputDirection = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	# SKICKAR TILLBAKA TILL MAIN MENU OM ESCAPE TRYCKS NED
	if Input.is_action_just_pressed("ui_cancel"): 
		get_tree().change_scene_to_file("res://UI/Menus/main_menu.tscn")
	
	# FLYTTAR FLASHLIGHT-BEAMEN MOT VÄNSTER ELLER HÖGER BASERAT PÅ VILKET HÅLL SOM TRYCKS INNE, ALTERNATIVT MOT MITTEN
	if Input.get_action_strength("down") - Input.get_action_strength("up") > 0:
		$Player/FlashlightNode.position.y = lerp($Player/FlashlightNode.position.y, 23.0, t * 2)
	elif Input.get_action_strength("down") - Input.get_action_strength("up") < 0:
		$Player/FlashlightNode.position.y = lerp($Player/FlashlightNode.position.y, -23.0, t * 2)
	else: $Player/FlashlightNode.position.y = lerp($Player/FlashlightNode.position.y, 0.0, t * 2)

	# GÖR SÅ ATT DET SER UT SOM ATT SPELAREN KOMMER IKAPP MED KAMERAN NÄR DEN SPRINGER, FÖR ATT GE EN ILLUSION AV HASTIGHET
	if Input.is_action_pressed("sprint") and player.stamina > 0 and player.staminaOnCooldown == 0 and player.velocity != Vector2.ZERO: 
		targetDistance -= 10
	
	# GÖR SÅ ATT targetOffset FÅR SITT VÄRDE, SAMT SÅ ATT PROGRAMMET VET VAD Muzzle ÄR OCH FLIPPAR SPELAREN OM DEN KOLLAR ÅT VÄNSTER
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
	
	# LERPAR KAMERAN MOT targetOffset, SAMT CALLAR PÅ move_muzzle()
	camera.offset = camera.offset.lerp(targetOffset, t)
	move_muzzle(muzzleFlip, t)

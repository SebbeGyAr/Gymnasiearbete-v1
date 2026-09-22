"extends Node2D

# HUR SMOOTH SJÄLVA LJUSSTRÅLEN RÖR SIG
const SMOOTH_SPEED = 10

# HUR MYCKET BATTERI SOM FÖRSVINNER VARJE DELTA
const BATTERY_DRAIN_SPEED = 0.001

var isFlickering = false
var isRandomFlickering = false
@onready var flashlight = $Flashlight
@onready var target = $FlashlightTarget

func _ready() -> void:
	random_flashlight_flicker_loop()

func _process(delta: float) -> void:
	# ANVÄNDER LERP FÖR ATT RÖRA FICKLAMPAN DIT MUSPEKAREN VISAR FAST MED EASE IN OUT EXPONENTIAL (TROR DET BLIR EASE IN OUT EXP)
	var t = 1.0 - exp(-SMOOTH_SPEED * delta)
	var direction = (get_global_mouse_position() - global_position)
	rotation = lerp_angle(rotation, direction.angle(), t)
	
	# OM SPELAREN INTE HAR FICKLAMPAN ELLER HAR INTE IGÅNG FICKLAMPAN ELLER INTE HAR NÅGOT BATTERI KVAR, STÄNG LJUSET, ANNARS TÄND LJUSET
	if not (GlobalVariables.hasFlashlight and GlobalVariables.flashlightEnabled) or GlobalVariables.flashlightBattery <= 0:
		flashlight.enabled = false
	else:
		flashlight.enabled = true
	
	# FLICKER EFFEKT NÄR BATTERIET ÄR UNDER 10%
	if GlobalVariables.flashlightBattery < 10 and GlobalVariables.flashlightEnabled: 
		flashlight_flicker()
		
	# DRÄNERAR BATTERI OM SPELAREN HAR FICKLAMPAN, DEN ÄR IGÅNG OCH HAR BATTERI. 
	if GlobalVariables.flashlightEnabled and GlobalVariables.hasFlashlight and GlobalVariables.flashlightBattery > 0: 
		GlobalVariables.flashlightBattery -= BATTERY_DRAIN_SPEED

func flashlight_flicker():
	# SER OM FICKLAMPAN REDAN FLICKERAR
	if isFlickering:
		return
	isFlickering = true
	
	# FLICKERAR MED INTERVALLERNA SOM SYNS UNDERTILL
	flashlight.energy = 0
	await get_tree().create_timer(randf_range(0, 0.1)).timeout
	
	flashlight.energy = 1
	await get_tree().create_timer(randf_range(0, 0.5)).timeout
	
	isFlickering = false

func random_flashlight_flicker_loop():
	# STÄNGER AV SIG SJÄLV OM DET SNABBA FLICKRANDET TAR ÖVER
	while GlobalVariables.flashlightBattery > 10:
		# VÄNTAR EN RANDOM PERIOD MELLAN 1 OCH 4 SEK OCH FLICKERAR, SAMMA SAFEGUARDS SOM VANLIGA flashlight_flicker()
		await get_tree().create_timer(randf_range(1.0, 4.0)).timeout
		isRandomFlickering = true
		flashlight.energy = 0
		
		await get_tree().create_timer(randf_range(0.0, 0.1)).timeout
		isRandomFlickering = false
		flashlight.energy = 1
"
extends Node2D

# HUR SMOOTH SJÄLVA LJUSSTRÅLEN RÖR SIG
const SMOOTH_SPEED = 10

# HUR MYCKET BATTERI SOM FÖRSVINNER VARJE DELTA
const BATTERY_DRAIN_SPEED = 0.001
const TARGET_BASE_POSITION = Vector2(25, 0)

var isFlickering = false
var isRandomFlickering = false
var lastInputDirection = Vector2.RIGHT
@onready var flashlight = $Flashlight
@onready var target = $FlashlightTarget


func _ready() -> void:
	random_flashlight_flicker_loop()

func _process(delta: float) -> void:
	var t = 1.0 - exp(-SMOOTH_SPEED * delta)
	var inputDirection = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"), 
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if inputDirection != Vector2.ZERO:
		lastInputDirection = inputDirection.normalized()
	
	# TAR SENASTE LOKALA POSITIONEN
	target.position = TARGET_BASE_POSITION.rotated(lastInputDirection.angle())
	
	# target.position ÄR SAMMA SOM RIKTNINGSVEKTORN EFTERSOM ÄNDRINGEN ÄR LOKAL
	rotation = lerp_angle(rotation, target.position.angle(), t)
	
	if not (GlobalVariables.hasFlashlight and GlobalVariables.flashlightEnabled) or GlobalVariables.flashlightBattery <= 0:
		flashlight.enabled = false
	else:
		flashlight.enabled = true
	
	if GlobalVariables.flashlightBattery < 10 and GlobalVariables.flashlightEnabled: 
		flashlight_flicker()
		
	if GlobalVariables.flashlightEnabled and GlobalVariables.hasFlashlight and GlobalVariables.flashlightBattery > 0: 
		GlobalVariables.flashlightBattery -= BATTERY_DRAIN_SPEED

func flashlight_flicker():
	if isFlickering:
		return
	isFlickering = true
	
	flashlight.energy = 0
	await get_tree().create_timer(randf_range(0, 0.1)).timeout
	
	flashlight.energy = 1
	await get_tree().create_timer(randf_range(0, 0.5)).timeout
	
	isFlickering = false

func random_flashlight_flicker_loop():
	while GlobalVariables.flashlightBattery > 10:
		await get_tree().create_timer(randf_range(1.0, 4.0)).timeout
		isRandomFlickering = true
		flashlight.energy = 0
		
		await get_tree().create_timer(randf_range(0.0, 0.1)).timeout
		isRandomFlickering = false
		flashlight.energy = 1

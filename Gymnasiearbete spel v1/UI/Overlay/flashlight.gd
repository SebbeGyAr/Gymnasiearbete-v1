extends Node2D

const SMOOTH_SPEED = 5
const BATTERY_DRAIN_SPEED = 0.005

@onready var flashlight = $Flashlight

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var t = 1.0 - exp(-SMOOTH_SPEED * delta)
	var direction = (get_global_mouse_position() - global_position)
	rotation = lerp_angle(rotation, direction.angle(), t)
	
	if not (GlobalVariables.hasFlashlight and GlobalVariables.flashlightEnabled) or GlobalVariables.flashlightBattery <= 0:
		flashlight.enabled = false
	else:
		flashlight.enabled = true
	
	if GlobalVariables.flashlightBattery < 10 and GlobalVariables.flashlightEnabled: 
		flashlight.energy = 0
		await get_tree().create_timer(randf()).timeout
		flashlight.energy = 1

	if GlobalVariables.flashlightEnabled and GlobalVariables.flashlightBattery > 0: 
		GlobalVariables.flashlightBattery -= BATTERY_DRAIN_SPEED

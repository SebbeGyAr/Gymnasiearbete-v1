extends Camera2D

@export var player : Node


"""
func _process(float) -> void: 
	
	set_position_smoothing_enabled(true)
	var inputDirection = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"), 
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

#	offset = inputDirection * 1
	var screen_width = get_viewport_rect().size.x
	var camera_target
	var target_distance = 100 # You can use screen_width if you want 1/x of the screen etc.
	var camera_speed = 6 # Multiply with delta if you want pixels/second
	if inputDirection.x < 0:
		camera_target = player.position.x + target_distance - screen_width/2
		offset.x = min(offset.x + camera_speed, camera_target)
	else:
		camera_target = player.position.x - target_distance - screen_width/2
		offset.x = max(offset.x - camera_speed, camera_target)
	offset.y = player.position.y
"""

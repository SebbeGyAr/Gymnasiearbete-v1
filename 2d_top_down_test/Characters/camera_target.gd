extends Camera2D

@export var player : Node

#func _process(float) -> void: 
#	var screen_width = get_viewport_rect().size.x
#	var camera_target
#	var target_distance = 100 # You can use screen_width if you want 1/x of the screen etc.
#	var camera_speed = 6 # Multiply with delta if you want pixels/second
#	if player.inputDirection.x < 0:
#		camera_target = $Player.position.x + target_distance - screen_width/2
#		$Camera.offset.x = min($Camera.offset.x + camera_speed, camera_target)
#	else:
#		camera_target = $Player.position.x - target_distance - screen_width/2
#		$Camera.offset.x = max($Camera.offset.x - camera_speed, camera_target)
#	$Camera.offset.y = $Player.position.y

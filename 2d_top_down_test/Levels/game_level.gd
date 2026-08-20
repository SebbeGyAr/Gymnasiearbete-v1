extends Node2D


var resolutions := { # resolutions list
	"4k":Vector2(3840,2160),
	"1440p":Vector2(2560,1440),
	"1080p":Vector2(1920,1080),
	"720p":Vector2(1280,720)
}

# KANSKE LÖSER SCREEN TEARING, GHOSTING OCH INPUT LAG VID 30 IFALL DET DYKER UPP VID HÖGRE
@export var maxFPS = 60
#@export var player: Node

func _ready():
	Engine.max_fps = maxFPS 

func _physics_process(delta: float) -> void:
	var inputDirection = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	#print($PlayerCharacter.get_screen_transform()[2].x)
	
	var target_distance = 100
	var camera_speed = 100 * delta
	
	var camera = $PlayerCharacter/Camera2D
	if inputDirection.x > 0: 
		camera.offset.x = min(camera.offset.x + camera_speed, target_distance)
		
	elif inputDirection.x < 0: 
		camera.offset.x = max(camera.offset.x - camera_speed, -target_distance)
		
	if inputDirection.y > 0:
		camera.offset.y = min(camera.offset.y + camera_speed, target_distance)
		
	elif inputDirection.y < 0:
		camera.offset.y = max(camera.offset.y - camera_speed, -target_distance)

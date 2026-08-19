extends Node2D


var resolutions := { # resolutions list
	"4k":Vector2(3840,2160),
	"1440p":Vector2(2560,1440),
	"1080p":Vector2(1920,1080),
	"720p":Vector2(1280,720)
}

# KANSKE LÖSER SCREEN TEARING, GHOSTING OCH INPUT LAG VID 30 IFALL DET DYKER UPP VID HÖGRE
@export var maxFPS = 60


func _ready():
	Engine.max_fps = maxFPS 

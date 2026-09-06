extends Node


@onready var player = "res://Player/player.tscn"
var musicProgress = 0.0
var stamina = 100.0
var musicSlider = 20
var fullscreen = false
var resolutionSet = 2
var framerateSet = 0
var vsync = false
var bulletsLeft = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

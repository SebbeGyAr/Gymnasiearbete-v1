extends Node


@onready var player = "res://Player/player.tscn"
var musicProgress = 0.0
var stamina = 100.0
var soundSlider = 30
var fullscreen = false
var resolutionSet = 2
var framerateSet = 0
var vsync = false
var bulletsLeft = 5
var hasFlashlight = true
var flashlightEnabled = true
var hasRifle = true
var flashlightBattery = 100
var canShoot = false
var playerCanShoot = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggleFlashlight"):
		flashlightEnabled = not flashlightEnabled
	if flashlightEnabled:
		canShoot = false
	elif not flashlightEnabled and hasRifle and playerCanShoot: 
		canShoot = true
		

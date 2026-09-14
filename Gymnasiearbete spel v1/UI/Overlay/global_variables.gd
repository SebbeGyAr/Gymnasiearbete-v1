extends Node

# MASSVIS MED GLOBALA VARIABLER
@onready var flashlightSprite: Sprite2D = null
var musicProgress = 0.0
var stamina = 100.0
var soundSlider = 20
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


func _process(_delta: float) -> void:
	# TOGGLE FLASHLIGHT FUNKTIONALITET
	if Input.is_action_just_pressed("toggleFlashlight"):
		toggle_flashlight()
	
	# EN TILLFÄLLIG KNAPP FÖR ATT KUNNA GE OCH TA FICKLAMPAN TILL OCH FRÅN SPELAREN, ANVÄNDNING 2 AV FUSKKNAPP
	if Input.is_action_just_pressed("cheatbutton"):
		hasFlashlight = not hasFlashlight
	
	# GÖR SÅ ATT FICKLAMPAN INTE KAN VARA IGÅNG OM SPELAREN INTE HAR FICKLAMPAN
	if not hasFlashlight: 
		flashlightEnabled = false
	
	# UPPDATERAR FLASHLIGHT SYNBARHET, BEHÖVS FÖR ATT KONSEKVENT KUNNA KOMMA IN UTAN ATT KRASCHA
	update_flashlight_visibility()

func set_flashlight_sprite(sprite: Sprite2D):
	# VÄNTAR PÅ ATT SPELARENS _ready() KAN KÖRA OCH ASSIGNA flashlightSprite ETT VÄRDE, SEDAN UPPDATERAR SYNBARHETEN
	flashlightSprite = sprite

	update_flashlight_visibility()

func toggle_flashlight():
	# DEL 2 AV TOGGLE FLASHLIGHT FUNKIONALITET
	flashlightEnabled = not flashlightEnabled
	update_flashlight_visibility()

func update_flashlight_visibility():
	# GÖR SÅ ATT MAN SER FLASHLIGHTEN KONSEKVENT SOM DET ÄR MENAT GENOM ATT UPPDATERA VARJE FRAME
	if flashlightSprite:
		flashlightSprite.visible = hasFlashlight
	
	# UPPDATERAR HUR SJÄLVA FICKLAMPE-SPRITEN SER UT OM DEN ÄR PÅ RESPEKTIVE AV, ENDAST OM FLASHLIGHTSPRITE HAR BLIVIT GIVET ETT VÄRDE AV SPELARENS _ready()
	if flashlightSprite != null:
		if flashlightEnabled: 
			flashlightSprite.frame = 1
		else: flashlightSprite.frame = 0

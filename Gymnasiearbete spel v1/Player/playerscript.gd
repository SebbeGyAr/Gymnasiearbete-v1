extends CharacterBody2D

# TILLFÄLLIG FUSKKNAPP: 0
# GÖR SÅ ATT ENS STAMINARECOVERYSPEED DUBBLERAS FÖR TESTSYFTE SAMT GER OCH TAR FICKLAMPAN FRÅN SPELAREN

const MOVEMENT_SPEED_CONST = 40
const SPRINT_SPEED = 1.5
const STAMINA_COOLDOWN_LENGTH = 100

# ASSIGNAR VARIABLER (OBV)
var movementSpeed = MOVEMENT_SPEED_CONST
var startingDirection = Vector2(0, 1)
var staminaOnCooldown = float(0)
var staminaRecoverySpeed = 0.25
var stamina = 100.0
var canShoot = true
@onready var animationTree = $AnimationTree
@onready var stateMachine = animationTree.get("parameters/playback")

# PRELOADAR SCENEN bullet.tscn SOM VARIABELN Bullet, SOM KAN INSTANTIERAS FÖR ATT SKJUTA
var Bullet = preload("res://Entities/Misc/bullet.tscn")

func _ready():
	# GÖR VAD SOM STÅR I BASICALLY PLAINTEXT
	update_animation_parameters(startingDirection)
	stamina = GlobalVariables.stamina
	GlobalVariables.set_flashlight_sprite($FlashlightPivot/FlashlightSprite)
	
func shoot():
	# STOPPAR SPELAREN FRÅN ATT KUNNA SKJUTA OM DET INTE FINNS KULOR KVAR
	if GlobalVariables.bulletsLeft <= 0: 
		return
	
	# LÅTER INTE SPELAREN SKJUTA ELLER RELOADA (DE FÖRLITAR SIG PÅ SAMMA BOOL) FÖRRÄN HELA PROCESSEN ÄR FÄRDIG
	canShoot = false

	# SÄNKER ANTALET KULOR SOM ÄR KVAR
	GlobalVariables.bulletsLeft -= 1

	# INSTANTIERAR SJÄLVA KULAN OCH SKICKAR DEN I DEN RIKTNING SOM MUSPEKAREN HAR FRÅN Muzzle
	var b = Bullet.instantiate()
	get_parent().add_child(b)
	b.global_position = $Muzzle.global_position
	var direction = (get_global_mouse_position() - $Muzzle.global_position).normalized()
	b.rotation = direction.angle()
	

	# EN LITEN "TEXTANIMATION" EFTER ATT HA SKJUTIT SOM BLEV SCHYSST, SOM OCKSÅ GÖR DET GANSKA TYDLIGT ATT MAN INTE KAN SKJUTA FÖRRÄN DEN ÄR SLUT
	$"../UI/GunMagNode/BulletCounterLabel".text = "Cocking.    : %s/5" %GlobalVariables.bulletsLeft
	await get_tree().create_timer(0.25).timeout
	$"../UI/GunMagNode/BulletCounterLabel".text = "Cocking..   : %s/5" %GlobalVariables.bulletsLeft
	await get_tree().create_timer(0.25).timeout
	$"../UI/GunMagNode/BulletCounterLabel".text = "Cocking...  : %s/5" %GlobalVariables.bulletsLeft
	await get_tree().create_timer(0.25).timeout
	$"../UI/GunMagNode/BulletCounterLabel".text = "Bullets Left: %s/5" %GlobalVariables.bulletsLeft
	
	# LÅTER SPELAREN SKJUTA OCH RELOADA IGEN FÖR ATT ALLA STEG OCH COOLDOWNS ÄR FÄRDIGA
	canShoot = true

func reload(): 
	# SER OM MAGASINET ÄR FULLT OCH LÅTER INTE SPELAREN RELOADA OM MAGASINET ÄR FULLT
	if GlobalVariables.bulletsLeft >= 5:
		return
	
	# STOPPAR SPELAREN FRÅN ATT KUNNA SKJUTA OCH RELOADA MEDANS SPELAREN RELOADAR
	canShoot = false
	
	# EN "TEXTANIMATION" SOM VISAR HUR MÅNGA KULOR SOM ÄR KVAR I MAGASINET VID VARJE STEG, SAMT SER SCHYSST UT
	while GlobalVariables.bulletsLeft < 5: 
		$"../UI/GunMagNode/BulletCounterLabel".text = "Reloading...: %s/5" % GlobalVariables.bulletsLeft
		await get_tree().create_timer(0.75).timeout
		GlobalVariables.bulletsLeft += 1
	$"../UI/GunMagNode/BulletCounterLabel".text = "Reloading...: %s/5" % GlobalVariables.bulletsLeft
	
	# EN SISTA TIMER SOM GÖR DET MINDRE LÖNSAMT ATT RELOADA EFTER VARJE SKOTT, 
	# DÅ DET TAR 0,75 SEKUNDER EFTER ATT HA FYLLT HELA MAGASINET INNAN MAN KAN SKJUTA IGEN, VILKET GÖR DET INEFFEKTIVT ATT RELOADA EFTER VARJE SKOTT
	await get_tree().create_timer(0.75).timeout
	
	# SÄTTER GlobalVariables.bulletsLeft TILL 5, JUST IN CASE SPELAREN LYCKAS MED NÅGOT SOM EN SLIGHT SAFEGUARD. 
	GlobalVariables.bulletsLeft = 5
	$"../UI/GunMagNode/BulletCounterLabel".text = "Bullets Left: %s/5" %GlobalVariables.bulletsLeft
	
	# LÅTER SPELAREN SKJUTA OCH RELOADA IGEN DÅ ALLA PROCESSER OCH COOLDOWNS ÄR KLARA
	canShoot = true
	

func _physics_process(_delta): 
	# CALLAR PÅ SKJUTFUNTKION OM canShoot OCH hasRifle STÄMMER SAMT ATT SPELAREN TRYCKER PÅ SKJUTKNAPPEN
	if Input.is_action_just_pressed("shoot") and canShoot and GlobalVariables.hasRifle:
		shoot()

	# CALLAR PÅ RELOADFUNTKION OM canShoot OCH hasRifle STÄMMER SAMT ATT SPELAREN TRYCKER PÅ RELOADKNAPPEN
	if Input.is_action_just_pressed("reload") and canShoot and GlobalVariables.hasRifle:
		reload()

	# INPUT RIKTNING LAGRAS I EN MATRIS [-1, -1] TILL [1, 1], GER 9 OLIKA MÖJLIGA INPUTRIKNINGAR, ALLA 8 MÖJLIGA RIKNINGAR + STILLASTÅENDE
	var inputDirection = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"), 
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
		
	# UPPDATERA ANIMATIONER RELATERADE TILL RÖRELSE OCH FICKLAMPA
	update_animation_parameters(inputDirection)
	
	# SPRINTFUNKTION, KOMMER TROLIGEN FINJUSTERAS MKT
	staminaOnCooldown = max(staminaOnCooldown - staminaRecoverySpeed, 0)

	var isSprinting = Input.is_action_pressed("sprint") and stamina > 0 and staminaOnCooldown == 0 and velocity != Vector2.ZERO
	
	if isSprinting:
		movementSpeed = MOVEMENT_SPEED_CONST * SPRINT_SPEED
		stamina -= 1
	else:
		movementSpeed = MOVEMENT_SPEED_CONST
		stamina = clamp(stamina + staminaRecoverySpeed, 0, 100)
		if stamina <= 0 and staminaOnCooldown == 0:
			staminaOnCooldown = STAMINA_COOLDOWN_LENGTH
	
	# TILLFÄLLIG FUSKFUNKTION ANVÄNDNING 1
	if Input.is_action_just_pressed("cheatbutton"): 
		staminaRecoverySpeed *= 2

	# KOLLAR VÄRDEN I TESTSYFTEN
	# print("
	# Stamina: ", stamina, "
	# StaminaOnCooldown: ", staminaOnCooldown, "
	# Velocity: ", velocity, "
	# StaminaRecoverySpeed: ", staminaRecoverySpeed)
			
	# SÄTTER VELOCITY
	velocity = inputDirection.normalized() * movementSpeed
	
	# LÅTER SPELAREN, WELL, MOVE AND SLIDE
	move_and_slide()
	
	# VÄLJER VILKEN ANIMATION SOM BÖR SPELAS
	pick_new_state()
	

func update_animation_parameters(moveInput : Vector2):
	# ANIMATIONUPPDATERINGSFUNKTION
	if moveInput != Vector2.ZERO:
		animationTree.set("parameters/Walk/blend_position", moveInput)
		animationTree.set("parameters/Idle/blend_position", moveInput) 

func pick_new_state():
	# BEDÖMER OM KARAKTÄREN GÅR, SPRINGER ELR STÅR STILLA, OCH KALLAR PÅ DEN RELEVANTA ANIMATIONEN
	if velocity != Vector2.ZERO:
		if Input.is_action_pressed("sprint") and stamina > 0 and staminaOnCooldown == 0 and velocity != Vector2.ZERO:
			stateMachine.travel("Run")

		else: 
			stateMachine.travel("Walk")
	else: 
		stateMachine.travel("Idle")

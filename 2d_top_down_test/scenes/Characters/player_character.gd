extends CharacterBody2D

# TILLFÄLLIG FUSKKNAPP: 0
# GÖR SÅ ATT ENS STAMINARECOVERYSPEED DUBBLERAS FÖR TESTSYFTE

const MOVEMENT_SPEED_CONST = 100
const SPRINT_SPEED = 1.75
const STAMINA_COOLDOWN_LENGTH = 100

var movementSpeed = MOVEMENT_SPEED_CONST
var startingDirection = Vector2(0, 1)
var staminaOnCooldown = float(0)
var staminaRecoverySpeed = 0.25
var stamina = 100.0
var canReload = true
var canShoot = true
var hasRifle = true
@onready var animationTree = $AnimationTree
@onready var stateMachine = animationTree.get("parameters/playback")

var Bullet = preload("res://scenes/Non Character Entities/bullet.tscn")

func _ready():
	update_animation_parameters(startingDirection)
	stamina = GlobalVariables.stamina


func shoot():
	if GlobalVariables.bulletsLeft <= 0: 
		return
	canShoot = false
	var b = Bullet.instantiate()
	get_parent().add_child(b)
	b.global_position = $Muzzle.global_position
	var direction = (get_global_mouse_position() - $Muzzle.global_position).normalized()
	b.rotation = direction.angle()
	GlobalVariables.bulletsLeft -= 1
	await get_tree().create_timer(0.75).timeout
	canShoot = true
	$"../UI/GunMagNode/BulletCounterLabel".text = "Bullets Left: %s/5" %GlobalVariables.bulletsLeft
	
func reload(): 
	canReload = false
	canShoot = false
	while GlobalVariables.bulletsLeft < 5: 
		$"../UI/GunMagNode/BulletCounterLabel".text = "Reloading... %s/5" % GlobalVariables.bulletsLeft
		await get_tree().create_timer(0.75).timeout
		GlobalVariables.bulletsLeft += 1
	$"../UI/GunMagNode/BulletCounterLabel".text = "Reloading... %s/5" % GlobalVariables.bulletsLeft
	await get_tree().create_timer(0.75).timeout
	canShoot = true
	canReload = true
	GlobalVariables.bulletsLeft = 5
	$"../UI/GunMagNode/BulletCounterLabel".text = "Bullets Left: %s/5" %GlobalVariables.bulletsLeft
	
func _physics_process(_delta): 
	if Input.is_action_just_pressed("shoot") and canShoot and hasRifle:
		shoot()
	if Input.is_action_just_pressed("reload") and canReload and hasRifle:
		reload()
	# INPUT RIKTNING LAGRAS I EN MATRIS [-1, -1] TILL [1, 1]
	var inputDirection = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"), 
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
		
	# UPPDATERA ANIMATIONER RELATERADE TILL RÖRELSE
	update_animation_parameters(inputDirection)
	
	# SPRINTFUNKTION, KOMMER TROLIGEN FINJUSTERAS MKT
	staminaOnCooldown = max(staminaOnCooldown - staminaRecoverySpeed, 0)

	var is_sprinting = Input.is_action_pressed("sprint") and stamina > 0 and staminaOnCooldown == 0 and velocity != Vector2.ZERO

	if is_sprinting:
		movementSpeed = MOVEMENT_SPEED_CONST * SPRINT_SPEED
		stamina -= 1
	else:
		movementSpeed = MOVEMENT_SPEED_CONST
		stamina = clamp(stamina + staminaRecoverySpeed, 0, 100)
		if stamina <= 0 and staminaOnCooldown == 0:
			staminaOnCooldown = STAMINA_COOLDOWN_LENGTH
	
	# TILLFÄLLIG FUSKFUNKTION
	if Input.is_action_just_pressed("cheatbutton"): 
		staminaRecoverySpeed *= 2
	
	GlobalVariables.stamina = stamina
	# KOLLAR VÄRDEN I TESTSYFTEN
	# print("
	# Stamina: ", stamina, "
	# StaminaOnCooldown: ", staminaOnCooldown, "
	# Velocity: ", velocity, "
	# StaminaRecoverySpeed: ", staminaRecoverySpeed)
			
	# SÄTTER VELOCITY
	velocity = inputDirection.normalized() * movementSpeed
	
	# VET EJ RIKTIGT VAD DESSA GÖR UTÖVER ATT DE LÅTER KARAKTÄREN RÖRA PÅ SIG
	move_and_slide()
	pick_new_state()
	

func update_animation_parameters(moveInput : Vector2):
	# ANIMATIONUPPDATERINGSFUNKTION
	if moveInput != Vector2.ZERO:
		animationTree.set("parameters/Walk/blend_position", moveInput)
		animationTree.set("parameters/Idle/blend_position", moveInput) 

func pick_new_state():
	# BEDÖMER OM KARAKTÄREN GÅR ELR EJ
	if velocity != Vector2.ZERO:
		stateMachine.travel("Walk")
	else: 
		stateMachine.travel("Idle")

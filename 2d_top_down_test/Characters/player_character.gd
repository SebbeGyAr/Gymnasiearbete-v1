extends CharacterBody2D

@export var movementSpeed : float = 50
@export var startingDirection : Vector2 = Vector2(0, 1)

@onready var animationTree = $AnimationTree
@onready var stateMachine = animationTree.get("parameters/playback")

func _ready():
	update_animation_parameters(startingDirection)

func _physics_process(_delta): 

	var inputDirection = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"), 
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	update_animation_parameters(inputDirection)

	velocity = inputDirection * movementSpeed
	
	move_and_slide()
	
	pick_new_state()
	
	return velocity

func update_animation_parameters(moveInput : Vector2):
	if(moveInput != Vector2.ZERO):
		animationTree.set("parameters/Walk/blend_position", moveInput)
		animationTree.set("parameters/Idle/blend_position", moveInput) 
		
func pick_new_state():
	if(velocity != Vector2.ZERO):
		stateMachine.travel("Walk")
	else: 
		stateMachine.travel("Idle")

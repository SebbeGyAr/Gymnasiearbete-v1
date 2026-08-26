extends CharacterBody2D

var bulletArea2D = "res://scenes/Non Character Entities/bullet_area_2d.gd"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	select_new_direction()
	pick_new_state()

func _on_body_entered(body) -> void:
	if body == bulletArea2D:
		$Sprite2D.queue_free()


# COW SPECIFIK KOD

enum COW_STATE { IDLE, WALK }

var moveSpeed = 15
@onready var animationTree = $AnimationTree
@onready var stateMachine = animationTree.get("parameters/playback")
@onready var sprite = $Sprite2D
var moveDirection = Vector2.ZERO
var currentState : COW_STATE = COW_STATE.IDLE

func _physics_process(_delta):
	velocity = moveDirection * moveSpeed
	
	move_and_slide()

func select_new_direction():
	moveDirection = Vector2(randi_range(-1, 1), randi_range(-1, 1))
	
	if moveDirection.x < 0:
		sprite.flip_h = true
	elif moveDirection.x > 0:
		sprite.flip_h = false

func pick_new_state():
	if currentState == COW_STATE.IDLE:
		stateMachine.travel("walk_right")
		currentState = COW_STATE.WALK
		
	if currentState == COW_STATE.WALK:
		stateMachine.travel("idle")
		currentState = COW_STATE.IDLE

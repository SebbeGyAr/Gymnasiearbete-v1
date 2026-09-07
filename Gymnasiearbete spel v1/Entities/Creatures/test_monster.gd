extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(9).timeout
	$AudioStreamPlayer.play()
	await get_tree().create_timer(5).timeout
	$AudioStreamPlayer.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

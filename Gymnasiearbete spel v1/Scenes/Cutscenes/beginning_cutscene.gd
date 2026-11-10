extends Control

@onready var textbox = $Textbox


func _ready() -> void:
	textbox.textReadRate = 0.02
	textbox.queue_text("Hej allihopa och välkomna idag till en helt ny video här på min kanal", "Stamsite")
	textbox.queue_text("Ohhh, you're so Portuguese", "Welcome")
	textbox.queue_text("He who is coming", "Welcome")
	textbox.queue_text("E", "Welcome")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if textbox.textQueue == [] and textbox.currentState == textbox.State.READY:
		get_tree().change_scene_to_file("res://Scenes/Playable Scenes/main_map.tscn")

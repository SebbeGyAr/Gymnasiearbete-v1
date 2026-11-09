extends Control

@onready var textbox = $Textbox


func _ready() -> void:
	textbox.queue_text("Hello my name is Markiplier")
	textbox.queue_text("Testing testing")
	textbox.queue_text("Working wonderfully")
	textbox.queue_text("It seems to me at least")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

extends Control

@onready var textbox = $Textbox
var counter = 0
var proceedBool = false

func _ready() -> void:
	textbox.textReadRate = 0.02
	await get_tree().create_timer(5).timeout
#	textbox.displayWithFont = load("res://Assets/Fonts/KimsBitHand.ttf")
	textbox.queue_text("Ugh... ", "You")
	textbox.queue_text("Okay, another deer hunting request from the municipality. ", "You")
	textbox.queue_text("Same as last time; I have to hunt down and kill 5 deer a day for a week. ", "You")
	textbox.queue_text("Apparently the deer population has been going wild for the past couple of weeks.", "You")
	textbox.queue_text("At least someone is taking responsibility. ", "You")
	textbox.queue_text("Unfortunately, that someone has to be me. ", "You")
	textbox.queue_text("What a lovely way to spend my time. ", "You")
	textbox.queue_text("God Damn, I'm driving out in the middle of nowhere. ", "You")
	textbox.queue_text("So far from everything. ", "You")
	textbox.queue_text("Hopefully, this ends up being a swift matter. ", "You")
	textbox.queue_text("So I can return home soon enough. ", "You")
	textbox.queue_text("But hey, look on the bright side; I will have food for years to come, if the deer flesh is of sufficient quality. ", "You")
	proceedBool = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if textbox.textQueue == [] and textbox.currentState == textbox.State.READY and proceedBool:
		await get_tree().create_timer(2).timeout

		if counter < 1:
			textbox.queue_text("Now I'm here! ", "You")
			textbox.queue_text("Let me get this over with. ", "You")

			counter += 1

		if counter == 1: 
			if textbox.textQueue == [] and textbox.currentState == textbox.State.READY:
				var tween = create_tween()
				tween.set_trans(Tween.TRANS_LINEAR)
				tween.tween_property($VideoStreamPlayer, "speed_scale", 0, 1)
				tween.connect("finished", change_scene)


func change_scene():
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scenes/Playable Scenes/main_map.tscn")

extends Control

@onready var textbox = $Textbox
var counter = 0
var proceedBool = false
var isFinishing = false

func _ready() -> void:
	var audioTween = create_tween()
	audioTween.set_trans(Tween.TRANS_LINEAR)
	audioTween.tween_property($AudioStreamPlayer, "volume_db", -50, 1.5)
	textbox.textReadRate = 0.02
	var videoTween = create_tween()
	videoTween.set_trans(Tween.TRANS_LINEAR)
	videoTween.tween_property($Panel, "modulate", Color(0.0, 0.0, 0.0, 0.0), 3)
	textbox.textReadRate = 0.02
	await get_tree().create_timer(4).timeout
#	textbox.displayWithFont = load("res://Assets/Fonts/KimsBitHand.ttf")
	textbox.queue_text("Ugh... ", "You")
	textbox.queue_text("Okay, another deer hunting request from the municipality. ", "You")
	textbox.queue_text("Same as last time; I have to hunt down and kill 5 deer a day for a week. ", "You")
	textbox.queue_text("Apparently the deer population has been going wild for the past couple of weeks.", "You")
	textbox.queue_text("At least someone is taking responsibility. ", "You")
	textbox.queue_text("Unfortunately, that someone has to be me. ", "You")
	textbox.queue_text("What a lovely way to spend my time. ", "You")
	textbox.queue_text("God Damn, I'm driving out in the middle of nowhere. ", "You")
	textbox.queue_text("I'm so far from everything. ", "You")
	textbox.queue_text("Hopefully, this ends up being a swift matter, so I can return home soon enough.  ", "You")
	textbox.queue_text("But hey, look on the bright side; I will have food for years to come, if the deer flesh is of sufficient quality. ", "You")
	
	proceedBool = true
	preload("res://Scenes/Playable Scenes/main_map.tscn")


func _process(_delta: float) -> void:
	if isFinishing or not proceedBool:
		return
	if textbox.textQueue.is_empty() and textbox.currentState == textbox.State.READY:
		if counter < 1:
			counter += 1
			
			await get_tree().create_timer(2).timeout
			textbox.queue_text("Now I'm here! ", "You")
			textbox.queue_text("Let me get this over with. ", "You")
			return
		
		isFinishing = true
		finish_scene()

func finish_scene():
	await get_tree().create_timer(1).timeout
	var audioTween = create_tween()
	var videoTween = create_tween()
	
	audioTween.set_trans(Tween.TRANS_LINEAR)
	audioTween.tween_property($AudioStreamPlayer, "volume_db", -100, 2)
	
	videoTween.set_trans(Tween.TRANS_LINEAR)
	videoTween.tween_property($VideoStreamPlayer, "speed_scale", 0, 2)
	
	await audioTween.finished
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scenes/Playable Scenes/main_map.tscn")

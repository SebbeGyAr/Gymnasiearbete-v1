extends CanvasLayer

# enum KAN ASSIGNA FLERA const SAMTIDIGT, ANVÄNDER SOM EN LISTA FÖR ATT HÅLLA REDA PÅ VILKET LÄGE TEXTBOXEN ÄR I
enum State {
	READY, 
	READING, 
	FINISHED
}

var textSkippable = true

var displayWithFont = null #load("res://Assets/Fonts/KimsBitHand.ttf")

# NUVARANDE LÄGE FÖR TEXTBOXEN
var currentState = State.READY

# SKAPAR EN TWEEN SÅ ATT TEXTEN KAN AVSLÖJAS LÅNGSAMT
var tween = create_tween()

# SJÄLVFÖRKLARLIG VARIABEL, HUR SNABBT TEXTEN AVSLÖJAS
var textReadRate = 0.05

var textQueue = []
var speakerQueue = []

# ENKLA ATT KALLA PÅ OM DE ÄR VARIABLER
@onready var textboxContainer = $TextboxContainer
@onready var speakerText = $TextboxContainer/MarginContainer/HBoxContainer/Speaker
@onready var info = $TextboxContainer/MarginContainer/Info
@onready var text = $TextboxContainer/MarginContainer/HBoxContainer/Text


# TILLFÄLLIG TESTFUNKTION, VET EJ VAD VI VILL HA I READY
func _ready() -> void:
	hide_textbox()


func _process(_delta: float) -> void:
	match currentState:
		State.READY:
			if not textQueue.is_empty():
				if displayWithFont: 
					display_text(displayWithFont)
				else: display_text()

		State.READING:
			if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_select")) and textSkippable:
				text.visible_characters = -1
				tween.stop()
				on_text_written()

		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_select"):
				change_state(State.READY)
				hide_textbox()

func queue_text(nextText, speaker="No Speaker"):
	textQueue.push_back(nextText)
	speakerQueue.push_back(speaker)
	

# GÖMMER TEXTRUTAN, OBV
func hide_textbox():
	speakerText.text = ""
	text.text = ""
	info.text = ""
	textboxContainer.hide()

# GISSA VAD, VISAR TEXTRUTAN, ARGUMENTET speaker GÖR SÅ ATT SPELAREN SER VEM SOM TALAR
func show_textbox(speaker):
	speakerText.text = "%s: " %speaker
	textboxContainer.show()
	

# LÄGGER TILL TEXT MHA TWEEN FÖR ATT LÅNGSAMT AVSLÖJA TEXTEN
func display_text(font=false):
	var addedText = textQueue.pop_front()
	var speaker = speakerQueue.pop_front()
	# SKAPAR EN TWEEN SÅ ATT TEXTEN KAN AVSLÖJAS LÅNGSAMT
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	
	if font: 
		text.add_theme_font_override("font", font)
	
	text.visible_characters = 0
	show_textbox(speaker)
	
	text.text = addedText
	
	change_state(State.READING)
	
	tween.tween_property(text, "visible_characters", len(addedText), len(addedText) * textReadRate)
	tween.connect("finished", on_text_written)


func on_text_written():
	change_state(State.FINISHED)
	info.text = "Press Space/Enter to continue"



func change_state(nextState):
	currentState = nextState

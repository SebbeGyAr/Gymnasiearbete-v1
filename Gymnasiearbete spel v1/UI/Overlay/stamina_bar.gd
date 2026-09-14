extends ProgressBar

var staminaBar = StyleBoxFlat.new()

@onready var player = $"../../../Player"

func _ready() -> void:
	# SÄTTER DE HÖGRA HÖRNORNA TILL RUNDADE MED 6 PX RADIE
	staminaBar.set_corner_radius(CORNER_BOTTOM_RIGHT, 6)
	staminaBar.set_corner_radius(CORNER_TOP_RIGHT, 6)

func _process(_delta):
	# TAR MÄNGDEN STAMINA VARJE FRAME OCH SÄTTER IN I VARIABELN VÄRDE FÖR ATT VISAS PÅ STAMINABAREN
	value = player.stamina
	
	# ÄNDRAR FÄRG, FYLLNINGSMÄNGD OCH TEXT OM player.staminaOnCooldown ÄR true
	if player.staminaOnCooldown: 
		add_theme_stylebox_override("fill", staminaBar)
		staminaBar.bg_color = Color("430000ff")

	# UPPDATERAR HUR FULL STAMINABAREN ÄR VARJE FRAME
	else: 
		add_theme_stylebox_override("fill", staminaBar)
		staminaBar.bg_color = Color("495e85ff")

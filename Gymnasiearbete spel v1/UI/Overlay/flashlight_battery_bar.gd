extends ProgressBar

var flashlightBatteryBar = StyleBoxFlat.new()

@onready var textLabel = $"../BATTERYTextLabel"

func _ready():
	# SÄTTER DE HÖGRA HÖRNORNA TILL RUNDADE MED 6 PX RADIE
	flashlightBatteryBar.set_corner_radius(CORNER_BOTTOM_RIGHT, 6)
	flashlightBatteryBar.set_corner_radius(CORNER_TOP_RIGHT, 6)

func _process(_delta):
	# TAR MÄNGDEN BATTERI VARJE FRAME OCH SÄTTER IN I VARIABELN VÄRDE FÖR ATT VISAS PÅ FLASHLIGHTBATTERYBAR
	value = GlobalVariables.flashlightBattery
	
	# ÄNDRAR FÄRG, FYLLNINGSMÄNGD OCH TEXT OM SLUT PÅ BATTERI
	if GlobalVariables.flashlightBattery <= 0: 
		add_theme_stylebox_override("fill", flashlightBatteryBar)
		flashlightBatteryBar.bg_color = Color("430000ff")
		value = 100
		textLabel.text = "EMPTY BATTERY"
	
	# UPPDATERAR HUR MYCKET BATTERI SOM VISAS ATT FINNAS KVAR VARJE FRAME
	else: 
		textLabel.text = "BATTERY: %d%%" % GlobalVariables.flashlightBattery
		add_theme_stylebox_override("fill", flashlightBatteryBar)
		flashlightBatteryBar.bg_color = Color("695e31ff")

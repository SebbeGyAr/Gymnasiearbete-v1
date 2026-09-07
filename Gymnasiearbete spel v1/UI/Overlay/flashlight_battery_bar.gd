extends ProgressBar

var flashlightBatteryBar = StyleBoxFlat.new()

@onready var textLabel = $"../BATTERYtextlabel"

func _process(_delta):
	value = GlobalVariables.flashlightBattery
	flashlightBatteryBar.set_corner_radius(CORNER_BOTTOM_RIGHT, 6)
	flashlightBatteryBar.set_corner_radius(CORNER_TOP_RIGHT, 6)
	if GlobalVariables.flashlightBattery <= 0: 
		add_theme_stylebox_override("fill", flashlightBatteryBar)
		flashlightBatteryBar.bg_color = Color("430000ff")
		flashlightBatteryBar.border_color = Color(0.19, 0.0, 0.0, 1.0)
		value = 100
		textLabel.text = "EMPTY BATTERY"
	else: 
		textLabel.text = "BATTERY: %d%%" % GlobalVariables.flashlightBattery
		add_theme_stylebox_override("fill", flashlightBatteryBar)
		flashlightBatteryBar.bg_color = Color("695e31ff")
		flashlightBatteryBar.border_color = Color("423b1fff")
	

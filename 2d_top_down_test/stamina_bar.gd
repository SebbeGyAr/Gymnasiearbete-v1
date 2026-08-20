extends ProgressBar

var staminaBar = StyleBoxFlat.new()

@export var player: Node

func _process(delta):
	value = player.stamina
	staminaBar.set_corner_radius(CORNER_BOTTOM_RIGHT, 6)
	staminaBar.set_corner_radius(CORNER_TOP_RIGHT, 6)
	if player.staminaOnCooldown: 
		add_theme_stylebox_override("fill", staminaBar)
		staminaBar.bg_color = Color("430000ff")
		staminaBar.border_color = Color(0.19, 0.0, 0.0, 1.0)
	else: 
		add_theme_stylebox_override("fill", staminaBar)
		staminaBar.bg_color = Color("495e85ff")
		staminaBar.border_color = Color(0.22, 0.283, 0.4, 1.0)
	

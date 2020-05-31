extends Control

var count = 2
var currentA = 255

func _ready():
	pass # Replace with function body.

func _process(delta):
	if count > 0:
		count-=delta
	elif currentA > 0:
		currentA-=delta*64
		$bg.get("custom_styles/panel").set_bg_color(Color8(0, 0, 0, currentA))
		$bg/Anchored.rect_position -= Vector2(0, delta*90.5)
	else:
		switcher_loader.goto_scene_fg("res://scenes/structure/main-menu.tscn")

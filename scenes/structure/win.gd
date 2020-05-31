extends Control

func _on_Menu_pressed():
	switcher_loader.goto_scene_fg("res://scenes/structure/main-menu.tscn")
	persist.reset_persists()

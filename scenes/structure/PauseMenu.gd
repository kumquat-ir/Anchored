extends Control


func _on_Quit_pressed():
	if OS.get_name() == "HTML5":
		switcher_loader.goto_scene_fg("res://scenes/structure/main-menu.tscn")
		persist.reset_persists()
	else:
		get_tree().quit()

func _on_Settings_pressed():
	$Main.visible = false
	$Settings.visible = true

func _on_Resume_pressed():
	get_tree().paused = false
	get_tree().call_group("main", "unpause")
	$Main.visible = true
	$Settings.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused == false:
			get_tree().call_group("main", "pause")
		else:
			get_tree().paused = false
			get_tree().call_group("main", "unpause")
			$Main.visible = true
			$Settings.visible = false

func _on_Back_pressed():
	$Main.visible = true
	$Settings.visible = false

func _on_MasterVolume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 20 * log(value/100)/log(10))
	#log10, because log() is ln, for some godforsaken reason

func _on_MusicVolume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 20 * log(value/100)/log(10))

func _ready():
	#set volume sliders to what they should be
	#db = 20*ln(val/100)/ln(10)
	#db * ln(10) / 20 = ln(val/100)
	#e^(db * ln(10) / 20) * 100 = val
	$Settings/MasterVolume.value = exp(AudioServer.get_bus_volume_db(
			AudioServer.get_bus_index("Master")) * log(10) / 20) * 100
	#because for some stupid reason there is no constant e, and I have to use exp
	$Settings/MusicVolume.value = exp(AudioServer.get_bus_volume_db(
			AudioServer.get_bus_index("Music")) * log(10) / 20) * 100

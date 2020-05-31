extends Control

func _ready():
	#set volume sliders to the correct values (see PauseMenu.gd)
	#probably will never come up, but whatever
	$Settings/MasterVolume.value = exp(AudioServer.get_bus_volume_db(
			AudioServer.get_bus_index("Master")) * log(10) / 20) * 100
	$Settings/MusicVolume.value = exp(AudioServer.get_bus_volume_db(
			AudioServer.get_bus_index("Music")) * log(10) / 20) * 100
	#get_tree().quit() does nothing on HTML5, remove quit button
	if OS.get_name() == "HTML5":
		$Main/Quit.visible = false

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_Settings_pressed():
	$Main.visible = false
	$Settings.visible = true

func _on_Start_pressed():
	switcher_loader.goto_scene("res://scenes/game/Game-main.tscn")


func _on_MasterVolume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 20 * log(value/100)/log(10))


func _on_MusicVolume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 20 * log(value/100)/log(10))


func _on_Back_pressed():
	$Main.visible = true
	$Settings.visible = false

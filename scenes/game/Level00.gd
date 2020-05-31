extends "res://scenes/game/Level.gd"

func _enter_tree():
	$TW0.active = persist.init_scene_persist(self, "TW0_ACTIVE", $TW0.active)
	$TW1.active = persist.init_scene_persist(self, "TW1_ACTIVE", $TW1.active)
	$GravFieldCircle.visible = persist.init_scene_persist(self, "GFC1_VISIBLE", $GravFieldCircle.visible)

func _exit_tree():
	persist.set_scene_persist(self, "TW0_ACTIVE", $TW0.active)
	persist.set_scene_persist(self, "TW1_ACTIVE", $TW1.active)
	persist.set_scene_persist(self, "GFC1_VISIBLE", true)

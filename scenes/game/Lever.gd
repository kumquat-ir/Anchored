extends Area2D

var plIn:bool = false
export(String) var callGroup = "wall"
export(String) var method = "toggle"
export(String) var index = 0
var state:bool = false

func _on_Lever_body_entered(body:Node):
	if body.is_in_group("player") and not plIn:
		plIn = true

func _on_Lever_body_exited(body:Node):
	if body.is_in_group("player") and plIn:
		plIn = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_down") and plIn:
		state = !state
		if callGroup != "SETPERSIST":
			get_tree().call_group(callGroup, method, index as int)
		else:
			persist.set_scene_persist_direct(method, index, !state)
		if $AnimatedSprite.animation == 'l':
			$AnimatedSprite.animation = 'r'
		else:
			$AnimatedSprite.animation = 'l'

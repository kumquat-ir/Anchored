extends Area2D

func _ready():
	pass

func _on_Area2D_body_entered(body:Node):
	if body.is_in_group("player"):
		get_tree().call_group("player", "gravitate", gravity_vec)

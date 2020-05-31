extends Area2D



func _on_Goal_body_entered(body:Node):
	if body.is_in_group("player"):
		switcher_loader.goto_scene("res://scenes/structure/win.tscn")

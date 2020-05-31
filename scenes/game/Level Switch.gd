extends Area2D

export(int) var height = 192
export(int) var index = -1
export(String) var connection = ""
export(int) var connectIndex = -1
export(Vector2) var dispVec = Vector2(65, 0)

func _ready():
	$CollisionShape2D.shape.extents.y = height/2
	$Sprite.rotation = dispVec.angle()
	$Sprite.position = -dispVec

func _on_Level_Switch_body_entered(body:Node):
	if body.is_in_group("player"):
		var pdisp:Vector2 = body.position - position
		pdisp.x = 0 #x is already accounted for, easier to add a vector to vectors than an int
		print("Switch level to " + connection + " index "
				+ str(connectIndex) + " (player displacement " + str(pdisp) + ")")
		get_tree().call_group("main", "loadLevel", connection, connectIndex, pdisp)

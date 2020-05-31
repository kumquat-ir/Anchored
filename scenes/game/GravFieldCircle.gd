extends Area2D

export(int, 1, 200) var inwid = 100
var plIn:bool = false
var pState = 'hold'

func _ready():
	$Area.shape.radius = inwid

func _on_GravFieldCircle_body_entered(body:Node):
	if body.is_in_group("player") and not plIn:
		plIn = true
		pState = 'out'
		$Pointer.rotation = gravity_vec.angle()


func _on_GravFieldCircle_body_exited(body:Node):
	if body.is_in_group("player") and plIn:
		plIn = false
		pState = 'in'

func _process(delta):
	if plIn and Input.is_action_just_pressed("ui_down"):
		print("gravitating player along " + str(gravity_vec))
		pState = 'in'
		get_tree().call_group("player", "gravitate", gravity_vec)
	if pState == 'out': #pointer goes out hehe
		if $Pointer.position.distance_to(Vector2(0, 0)) < 65: #65px from center in rot dir
			$Pointer.position += Vector2(cos($Pointer.rotation), sin($Pointer.rotation)) * 65 * delta * 5
		else:
			$Pointer.position = Vector2(cos($Pointer.rotation), sin($Pointer.rotation)) * 65
			pState = 'hold'
	if pState == 'in':
		if $Pointer.position.distance_to(Vector2(0, 0)) > 5:
			$Pointer.position -= Vector2(cos($Pointer.rotation), sin($Pointer.rotation)) * 65 * delta * 5
		else:
			$Pointer.position = Vector2(0, 0)
			pState = 'hold'

extends KinematicBody2D

export(int) var runSpeed = 400
export(int) var jumpSpeed = 700
export(int) var gravity = 1200
export(float) var xFriction = 1.1
var adjRunSpeed = runSpeed*(xFriction-1)
#number to add/subtract to make equivalence point of division/addition equal to runSpeed
#runSpeed = (adjRunSpeed+runSpeed)/xFriction : actual run speed = runSpeed
#runSpeed*xFriction = adjRunSpeed+runSpeed
#runSpeed*(xFriction-1) = adjRunSpeed

var velocity:Vector2 = Vector2()
var jumping:bool = false
var facing:String = 'r'
var anim:String = 'still'
var rotTarget:float = 0
var rotDelta:float = 0
#var camlims:Array #Camera2D limits do not work with Camera2D.rotating = true
var state:String = 'idle'

func _ready():
	pass

func setPos(pos:Vector2):
	position = pos
	print("set player position to " + str(position))

func setExtents(lwidth:int, lheight:int):
	print("recieve setExtents: " + str(lwidth) + "/" + str(lheight))
	$Camera.limit_left = 0
	$Camera.limit_top = 0
	$Camera.limit_right = lwidth
	$Camera.limit_bottom = lheight

func getInput():
	adjRunSpeed = runSpeed*(xFriction-1) #real run speed is effected by friction, adjust so it isn't
	velocity.x /= xFriction #in this house we do not stan instant stops :pensive:
	if abs(velocity.x) < 0.0001: #prevent microslide
		velocity.x = 0
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var jump = Input.is_action_just_pressed("ui_select") or Input.is_action_just_pressed("ui_up") #ui_select = space
	
	match is_on_floor():
		true:
			if velocity.x == 0:
				anim = 'still'
			else:
				anim = 'walk'
		false:
			if velocity.y > 0:
				anim = 'fall'
			else:
				anim = 'jump'
	
	$Sprite.animation = anim + "-" + facing
	
	if jump and is_on_floor():
		jumping = true
		velocity.y = -jumpSpeed #because negative jump speed just doesn't make sense to me
	if left:
		velocity.x -= adjRunSpeed
		if not right and facing == 'r':
			facing = 'l'
	if right:
		velocity.x += adjRunSpeed
		if not left and facing == 'l':
			facing = 'r'
	if left and right: #correct for when both keys are pressed
		if facing == 'l':
			velocity.x -= adjRunSpeed*.1
		elif facing == 'r':
			velocity.x += adjRunSpeed*.1

func gravitate(dir:Vector2 = Vector2(0,1)):
	if state != 'rot':
		print("set rotation to " + str(dir.angle()-PI/2) + " from " + str(rotation) + " using " + str(dir))
		#camlims = [$Camera.limit_right, $Camera.limit_top, $Camera.limit_left, $Camera.limit_bottom]
		#$Camera.limit_right = 10000000 #why is camera2D bad
		#$Camera.limit_top = -10000000
		#$Camera.limit_left = -10000000
		#$Camera.limit_bottom = 10000000
		rotTarget = dir.angle()-PI/2 #correct for weird angle-y shit
		state = 'rot'
		#CanvasLayer.transform?

func _process(delta):
	$Sprite.speed_scale = abs(velocity.x / 400)
	if state == 'rot':
		$Sprite.speed_scale = 0
		if rotDelta == 0 and abs(rotation + rotTarget) < 0.1 and abs( abs(rotTarget) - PI ) < 0.1:
			state = 'idle'
		elif abs(rotation - rotTarget) > 0.1:
			set_physics_process(false)
			if rotDelta == 0:
				rotDelta = rotTarget - rotation
			rotate(rotDelta*delta)
		else:
			rotDelta = 0
			rotation = rotTarget
			set_physics_process(true)
			#$Camera.limit_right = camlims[0]
			#$Camera.limit_top = camlims[1]
			#$Camera.limit_left = camlims[2]
			#$Camera.limit_bottom = camlims[3]
			state = 'idle'

func _physics_process(delta):
	getInput()
	velocity.y += gravity * delta
	if jumping and is_on_floor():
		jumping = false
	velocity = move_and_slide(velocity.rotated(rotation), Vector2(0, -1).rotated(rotation)).rotated(-rotation)
	#R O T A T O

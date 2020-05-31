extends KinematicBody2D

export(int) var runSpeed = 100
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

func _ready():
	pass

func getInput():
	adjRunSpeed = runSpeed*(xFriction-1) #real run speed is effected by friction, adjust so it isn't
	velocity.x /= xFriction #in this house we do not stan instant stops :pensive:
	if abs(velocity.x) < 0.0001: #prevent microslide
		velocity.x = 0
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var jump = Input.is_action_just_pressed("ui_select") or Input.is_action_just_pressed("ui_up") #ui_select = space
	
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
	print("set rotation to " + str(dir.angle()-PI/2) + " from " + str(rotation) + " using " + str(dir))
	rotation = dir.angle()-PI/2 #correct for weird angle-y shit

func _physics_process(delta):
	getInput()
	velocity.y += gravity * delta
	if jumping and is_on_floor():
		jumping = false
	velocity = move_and_slide(velocity.rotated(rotation), Vector2(0, -1).rotated(rotation)).rotated(-rotation)

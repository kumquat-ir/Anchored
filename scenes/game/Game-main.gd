#~~copypasted~~heavily referenced the tutorials on this
extends Node2D

var loader
var wait_frames
var time_max = 100 #ms
var current_scene:Node
var currentConnectionLevel:String = ""
var currentConnectionIndex:int = -1
var currentPlayerDisplace:Vector2
var state:String = 'fi' #fade in at start

func _ready():
	var levelg = get_tree().get_nodes_in_group("level")
	current_scene = levelg[0]
	if(len(levelg) > 1):
		printerr("There is more than one level instantiated on game ready: needs fix")
	$fg/black.color.a = 1

func pause():
	$fg/PauseMenu.visible = true
	get_tree().paused = true

func unpause():
	$fg/PauseMenu.visible = false

func loadLevel(level:String, connectIndex:int, pdisp:Vector2):
	currentConnectionLevel = level
	currentConnectionIndex = connectIndex
	currentPlayerDisplace = pdisp
	state = 'fo'
	get_tree().call_group("player", "set_physics_process", false)
	set_process(true) #god this is klugey
	goto_scene("res://scenes/game/" + level + ".tscn")

func goto_scene(path): #go to a new scene
	loader = ResourceLoader.load_interactive(path)
	if loader == null: #something has gone horribly wrong
		return
	set_process(true)
	get_node("/root/simple_load//simple-load").show() #loading screen has entered the chat
	get_node("/root/simple_load//simple-load").hidebg()
	current_scene.queue_free() #remove old scene
	wait_frames = 1

func _process(delta):
	if state == 'fo': #fade screen out to black
		if $fg/black.color.a < 1:
			$fg/black.color.a += delta*3
		else:
			state = 'go'
		return
	elif state == 'fi': #fade screen in from black
		if $fg/black.color.a > 0:
			$fg/black.color.a -= delta*3
		else:
			state = 'wa'
		return
	if loader == null: #no need
		set_process(false)
		return
	if wait_frames > 0: #wait for anim
		wait_frames-=1
		return
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t+time_max:
		var err = loader.poll()
		if err == ERR_FILE_EOF: #it's done
			var resource = loader.get_resource()
			set_new_scene(resource)
			loader = null
			get_node("/root/simple_load//simple-load").hide() #loading screen has left the chat
			get_node("/root/simple_load//simple-load").showbg()
			break
		elif err == OK: #goin'
			update_progress()
		else: #uh oh
			loader = null
			break

func update_progress(): #updates loading bar
	var progress = float(loader.get_stage())/loader.get_stage_count()
	get_node("/root/simple_load//simple-load/prog-bar").set_value(progress)

func set_new_scene(scene_resource): #instance new scene and add to tree
	current_scene = scene_resource.instance()
	$".".add_child(current_scene)
	move_child(current_scene, 0) #keep above player in tree
	state = 'fi'
	var switches = get_tree().get_nodes_in_group("switch") #move player to correct connected switch
	for switch in switches:
		if switch.index == currentConnectionIndex:
			print("found switch " + str(currentConnectionIndex) + " in " + currentConnectionLevel
						 + " at " + str(switch.position) + " with vector " + str(switch.dispVec))
			get_tree().call_group("player", "setPos", switch.position + switch.dispVec + currentPlayerDisplace)
			get_tree().call_group("player", "set_physics_process", true)

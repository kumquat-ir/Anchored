#~~copypasted~~heavily referenced the tutorials on this
extends Node

var loader
var wait_frames
var time_max = 100 #ms
var current_scene

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count()-1) #default active scene

func goto_scene_fg(path): #go to a new scene without the loading animation
	call_deferred("_deferred_goto_scene_fg", path) #need to wait for processes to finish before they are killed

func _deferred_goto_scene_fg(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)

func goto_scene(path): #go to a new scene
	loader = ResourceLoader.load_interactive(path)
	if loader == null: #something has gone horribly wrong
		return
	set_process(true)
	get_node("/root/simple_load//simple-load").show() #loading screen has entered the chat
	current_scene.queue_free() #remove old scene
	wait_frames = 1

func _process(_delta):
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
			loader = null
			set_new_scene(resource)
			get_node("/root/simple_load//simple-load").hide() #loading screen has left the chat
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
	get_node("/root").add_child(current_scene)

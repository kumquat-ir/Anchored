extends Node


#-------PLAYER / WORLD FLAGS-------
#Stored binary global flags as bits in integers
var playerState1:int = 0
#PLAYER FLAGS 1:


#-------SCENE FLAGS-------
#Dynamically assigned nested dictionary of scene-specific flags/values
var SCENE_FLAGS = {}

#When calling from target scene, self should be passed to nodeIn
#Code in affected classes being affected by persistent properties should handle them in _ready()
func get_scene_persist(nodeIn:Node, property:String):
	#If nodeIn/property exists, return its current value
	#If nodeIn/property does not exist, return null
	var nname:String = nodeIn.filename.rsplit("/", false, 1)[1].rstrip(".tscn")
	#boils down node name: ex. res://scenes/game/Level02.tscn -> Level02
	if SCENE_FLAGS.has(nname) and SCENE_FLAGS[nname].has(property): #make sure the keys exist
		return SCENE_FLAGS[nname][property]
	return null

func set_scene_persist(nodeIn:Node, property:String, value):
	#Sets nodeIn/property to value, creating it if non-existant
	#Should be called from _exit_tree()
	var nname:String = nodeIn.filename.rsplit("/", false, 1)[1].rstrip(".tscn")
	if !SCENE_FLAGS.has(nname): #create scene dict if it doesn't exist
		SCENE_FLAGS[nname] = {}
	SCENE_FLAGS[nname][property] = value
	print("SET SCENE PERSIST: " + nname + "/" + property + " : " + str(value))

func init_scene_persist(nodeIn:Node, property:String, initValue):
	#If nodeIn/property does not exist, creates it with initValue and returns initValue
	#If nodeIn/property exists, returns its current value
	#Should be called from _enter_tree(), as example:
	#   valvar = persist.init_scene_persist(self, "VALVAR", valvar)
	var initialized = get_scene_persist(nodeIn, property)
	if initialized == null:
		set_scene_persist(nodeIn, property, initValue)
		return initValue
	return initialized

func set_scene_persist_direct(nname:String, property:String, value):
	if !SCENE_FLAGS.has(nname): #create scene dict if it doesn't exist
		SCENE_FLAGS[nname] = {}
	SCENE_FLAGS[nname][property] = value
	print("SET SCENE PERSIST: " + nname + "/" + property + " : " + str(value))


#-------RESET-------
func reset_persists():
	playerState1 = 0
	SCENE_FLAGS = {}

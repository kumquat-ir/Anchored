extends Node2D

#only used for setExtents, unncessasary
#export(int) var lwidth
#export(int) var lheight 

func _ready():
	pass
	#setExtents sets camera limits, which do not work with Camera2D rotation
	#print("emit setExtents: " + str(lwidth) + "/" + str(lheight))
	#if lwidth >= 1920 and lheight >= 1080:
	#	get_tree().call_group("player", "setExtents", lwidth, lheight)
	#else:
	#	printerr("level extents smaller than camera bounds!")

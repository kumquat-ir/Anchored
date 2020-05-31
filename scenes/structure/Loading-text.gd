extends Label

var numdots:int = 0
var anchor:Node

func _ready():
	anchor = get_node("../Anchor-sprite")
	anchor.playing = true

func _on_Anchor_frame_changed(): #make the dots go dot dot dot
	if anchor.frame%8==0:
		numdots+=1 if anchor.frame!=0 else 0 #stupid 25 frame animation...
		numdots%=4
		var dotString:String = ""
		for _i in range(numdots):
			dotString+=" ."
		text = "L o a d i n g" + dotString #k e r n i n g

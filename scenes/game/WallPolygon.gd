extends StaticBody2D

export(int) var togIndex = -1
var active = true

func _ready():
	$CollisionPolygon2D.polygon = $Polygon2D.polygon
	if active == false:
		collision_layer ^= 1
		collision_mask ^= 1
		$Polygon2D.color.a8 ^= 128

func toggle(targIndex:int):
	if targIndex == togIndex:
		active = !active
		collision_layer ^= 1 #bitwise XOR: 1 = 00000000000000000001, causing low bit to swap
		collision_mask ^= 1
		$Polygon2D.color.a8 ^= 128 #swap high bit: 128 = 10000000, halves/doubles alpha

extends Control

func _ready():
	pass

func show():
	self.visible = true

func hide():
	self.visible = false

func showbg():
	$bg.visible = true

func hidebg():
	$bg.visible = false

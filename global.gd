extends Node

var last_position = Vector2(0,0)
var recoil = 300
var jump = 666
var run = 200

func update_position(point):
	last_position = point

func update_mc(x,y,z):
	recoil = x
	jump = y
	run = z

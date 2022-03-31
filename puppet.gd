extends KinematicBody2D

# Declare member variables here. Examples:
const UP =  Vector2(0,-1)
const GRAVITY = 9.8
const MAXFALLSPEED = 2000
const MAXSPEED = 100
const ACCELERATION = 100
var motion = Vector2()

func _ready():
	set_physics_process(false)
	motion.x = -MAXSPEED
	
func _physics_process(_delta):
		
	motion.y += GRAVITY
	
	motion.y = move_and_slide(motion,UP).y
	
func _process(_delta):
	
	if motion.x != 0:
		$AnimationPlayer.play("walk")
	
	if motion.x < 0:
		$Sprite.scale.x = 0.8
	elif motion.x > 0:
		$Sprite.scale.x = -0.8

extends KinematicBody2D

# Declare member variables here. Examples:
const UP =  Vector2(0,-1)
const GRAVITY = 9.8
const MAXFALLSPEED = 2000
const MAXSPEED = 100
const ACCELERATION = 100
var motion = Vector2()
var isAttacking = false
export (int) var health = 5
var notactive = false

func _ready():
	set_physics_process(false)
	motion.x = -MAXSPEED

func _physics_process(_delta):
	if notactive:
		return
	if $AnimationPlayer.current_animation == "attack":
		return 
		
	if is_on_wall():
		motion.x *= -1
	if not $Sprite/RayCast2D.is_colliding():
		motion.x *= -1
		
	motion.y += GRAVITY
	
	motion.y = move_and_slide(motion,UP).y

func _process(_delta):
	if notactive:
		return
	if $AnimationPlayer.current_animation == "hit":
		return
	if $AnimationPlayer.current_animation == "attack":
		return 
	
	if motion.x != 0:
		$AnimationPlayer.play("run")
	
	if motion.x < 0:
		$Sprite.scale.x = 0.8
	elif motion.x > 0:
		$Sprite.scale.x = -0.8

func _on_attack_body_entered(_body):
	if notactive:
		return
	var player = get_tree().get_root().find_node("player",true,false)
	if player:
		player.death()

func _on_dectector_right_body_entered(_body):
	if notactive:
		return
	$Sprite.scale.x = -0.8
	$AnimationPlayer.play("attack")
	motion.x = MAXSPEED

func _on_dectector_left_body_entered(_body):
	if notactive:
		return
	$Sprite.scale.x = 0.8
	$AnimationPlayer.play("attack")
	motion.x = -MAXSPEED

func hit():
	health -= 1
	if health <= 0:
		$CollisionShape2D.disabled = true
		death()
	else:
		$AnimationPlayer.play("hit")

func activeon():
	notactive = true
func activeoff():
	notactive = false

func death():
	notactive = true
	set_physics_process(false)
	#set_process(active)
	set_process_input(false)
	$AnimationPlayer.play("death")

func die():
	queue_free()

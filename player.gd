extends KinematicBody2D

# Declare member variables here. Examples:
const UP =  Vector2(0,-1)
const GRAVITY = 9.8
const MAXFALLSPEED = 1000
var MAXSPEED = Global.run
const ACCELERATION = 10
var MAXJUMPFORCE = Global.jump
var motion = Vector2()
var facing_right = true
var attack_active = false
var animation_active = false
var isactive = false
var isdead = false
export (int) var damage = 1
var isattacking = false
var isstarted = true
var JUMPCOUNT = 0
var recoil = false
var run_active = true
var MAXRECOILSPEED = Global.recoil

export(String, FILE, "*.json") var script_file
var script_ = []
# Called when the node enters the scene tree for the first time.

func _ready():
	#if isstarted:
	script_ = load_script()
	if script_[0]["opening"] == "yes":
		$PlayerAnimation.play("Opening")
	else:
		$PlayerAnimation.play("start")
	if script_[0]["palace"] == "yes":
		use_dialogue()
	Global.update_position(self.position)
	#pass

func _physics_process(_delta):
	
	if $PlayerAnimation.current_animation == "Opening":
		return 
	if $PlayerAnimation.current_animation == "flashback":
		return
	elif isactive:
		return
	
	# determine facing direction
	if facing_right == true:
		$PlayerSprite.scale.x = 0.16
	else:
		$PlayerSprite.scale.x = -0.16
		
	# create left-right motion
	if Input.is_action_pressed('right'):
		if motion.x < MAXSPEED:
			motion.x += ACCELERATION
		else:
			motion.x = MAXSPEED
		facing_right = true 
		#$AnimationPlayer.play("Run")
	elif Input.is_action_pressed('left'):
		if motion.x > -MAXSPEED:
			motion.x += -ACCELERATION
		else:
			motion.x = -MAXSPEED
		facing_right = false 
		#$AnimationPlayer.play("Run")
	else:
		motion.x = 0
	# create gravity engine
	motion.y += GRAVITY
	if GRAVITY > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
		
	if recoil:
		if facing_right == true:
			motion.x = -MAXRECOILSPEED
		else:
			motion.x = MAXRECOILSPEED
	
	# allow movement
	motion = move_and_slide(motion,UP)
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = -MAXJUMPFORCE
			#$AnimationPlayer.play("Jump")
			#JUMPCOUNT += 1
	
	if Input.is_action_just_pressed("attack"):
		motion.x = 0 
		#isattacking = true
		$PlayerAnimation.play("attack")
		$audio_dash.play()
		
func _process(_delta):
	
	if $PlayerAnimation.current_animation == "Opening":
		return 
	if $PlayerAnimation.current_animation == "attack":
		return
	if $PlayerAnimation.current_animation == "flashback":
		return
	if isactive:
		return
	if !is_on_floor():
		if $PlayerAnimation.current_animation == "fall":
			return
	if $PlayerAnimation.current_animation == "jump":
		return
		
	if motion.x == 0:
		$PlayerAnimation.play("idle")
		#$audio_run.stop()
	else:
		$PlayerAnimation.play("Run")

	if motion.y < 0:
		$PlayerAnimation.play("jump")
	if motion.y > 0:
		$PlayerAnimation.play("fall")

		
	#if Input.is_action_just_pressed("right"):
		#$audio_run.play()
	#if Input.is_action_just_pressed("left"):
		#$audio_run.play()
	if run_active:
		if is_on_floor() and motion.x != 0:
			$audio_run.play()
			run_active = false
	if !is_on_floor():
		run_active = true
		$audio_run.stop()
	if motion.x == 0:
		$audio_run.stop()
		run_active = true

func set_active(active):
	set_physics_process(active)
	#set_process(active)
	set_process_input(active)
	
func player_off():
	set_physics_process(false)
	#set_process(active)
	set_process_input(false)

func ani_flashback():
	notactive()
	$PlayerAnimation.play('flashback')
func ani_death():
	notactive()
	$PlayerAnimation.play('death')
func ani_end():
	notactive()
	$PlayerAnimation.play("The End")

func notactive():
	isactive = true
	
func yesactive():
	isactive = false
	
func death():
	notactive()
	$PlayerAnimation.play('grave')
	$deathtimer.start()

func _on_deathtimer_timeout():
	spawn()

func _on_weapon_body_entered(body):
	if body.has_method("hit"):
		body.hit()

func recoil_on():
	recoil = true
func recoil_off():
	recoil = false

func load_script():
	var file = File.new()
	if file.file_exists(script_file):
		file.open(script_file, file.READ)
		return parse_json(file.get_as_text())

func spawn():
	self.position = Global.last_position
	$deathtimer.stop()
	$PlayerAnimation.play("start")
	no_movement()
	recoil_off()

func no_movement():
	motion.x = 0
	motion.y = 0 

func stemn():
	MAXSPEED += 12
	MAXJUMPFORCE += 20
	MAXRECOILSPEED -= 25
	Global.update_mc(MAXRECOILSPEED,MAXJUMPFORCE,MAXSPEED)

func use_dialogue():
	var dialogue_player = get_node_or_null("DialoguePlayer")
	
	if dialogue_player:
		dialogue_player.play()

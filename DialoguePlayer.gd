extends CanvasLayer


# Declare member variables here. Examples:
export(String, FILE, "*.json") var dialogue_file

var dialogue = []
var dialogue_count = 0
var is_active = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$NinePatchRect.visible = false
	#play()

func play():
	if is_active:
		return
		
	dialogue = load_dialogues()
	
	is_active = true
	player_off()
	
	$NinePatchRect.visible = true

	dialogue_count = -1
	next_line()
	
func _input(event):
	if not is_active:
		return
		
	if event.is_action_pressed("interact"):
		next_line()
	
func next_line():
	dialogue_count += 1
	if dialogue_count >= len(dialogue):
		$Timer.start()
		$NinePatchRect.visible = false
		player_on()
		return
		
	$NinePatchRect/name.text = dialogue[dialogue_count]["name"]
	$NinePatchRect/message.text = dialogue[dialogue_count]["message"]
	
	if dialogue[dialogue_count]["message"] == 'enter flashback':
		#$scenetimer.start()
		var player = get_tree().get_root().find_node("player",true,false)
		if player:
			player.ani_flashback()
			
	if dialogue[dialogue_count]["message"] == 'dies':
		var player = get_tree().get_root().find_node("player",true,false)
		if player:
			player.ani_death()
		var npc = get_tree().get_root().find_node("Master",true,false)
		if npc:
			player_on()
			npc.queue_free()
			
	if dialogue[dialogue_count]["message"] == 'the end':
		var player = get_tree().get_root().find_node("player",true,false)
		if player:
			player.ani_end()
		
			
func load_dialogues():
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())

func _on_Timer_timeout():
	is_active = false
	

#func _on_scenetimer_timeout():
	is_active = false


func player_on():
	var player = get_tree().get_root().find_node("player",true,false)
	if player:
		player.set_active(true)
		
func player_off():
	var player = get_tree().get_root().find_node("player",true,false)
	if player:
		player.set_active(false)


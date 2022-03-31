extends Area2D

var not_collected = true

func _ready():
	set_physics_process(false)
	
func _process(_delta):
	if not_collected:
		$AnimationPlayer.play("idle")
	


func _on_Area2D_body_entered(body):
	not_collected = false
	var player = get_tree().get_root().find_node("player",true,false)
	if player:
		player.stemn()
	$AnimationPlayer.play("collect")
	$AudioStreamPlayer2D.play()

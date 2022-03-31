extends Area2D


# Declare member variables here. Examples:
export var next_scene: PackedScene

func _on_portal2d_body_entered(_body):
	teleport()
	
func _get_configuration_warning() -> String:
	return "The nest scene property can'r be empty" if not next_scene else ""
	
func teleport():
	$AnimationPlayer.play("fade_out")
	yield($AnimationPlayer,"animation_finished")
	get_tree().change_scene_to(next_scene)




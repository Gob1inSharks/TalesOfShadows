extends Area2D

func _on_point_body_body_entered(_body):
	Global.update_position(self.position)
		


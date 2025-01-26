extends Area3D

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("add_oxygen"):
			body.add_oxygen(40)
		queue_free()

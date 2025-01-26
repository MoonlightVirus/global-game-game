extends Area2D

@onready var pop = $pop

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("add_oxygen"):
			body.add_oxygen(40)
		pop.play()
		queue_free()

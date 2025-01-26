extends Node2D

@export var duration = 1.0  # Duration the overlay remains visible
@onready var sprite = $bubble_overlay

func _ready():
	sprite.visible = true  # Ensure the sprite starts visible
	start_effect()

func start_effect():
	# Schedule the overlay to disappear after the duration
	await get_tree().create_timer(duration).timeout
	queue_free()

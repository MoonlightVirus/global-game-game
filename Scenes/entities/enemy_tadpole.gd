extends CharacterBody2D

@export var speed = 40.0
var player = null
var is_frozen = false  # Track if the enemy is frozen
@export var bubble_overlay_scene = preload("res://Scenes/entities/bubble_overlay.tscn")  # Overlay bubble scene
var bubble_overlay = null  # Store the instance of the bubble overlay

func _ready():
	# Ensure the overlay instance is ready but not visible initially
	bubble_overlay = bubble_overlay_scene.instantiate()
	add_child(bubble_overlay)
	bubble_overlay.visible = false

func _physics_process(delta):
	if not is_frozen and player != null:
		position += (player.global_position - position).normalized() * speed * delta
		look_at(player.global_position)

func _on_detection_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_detection_body_exited(body):
	if body == player:
		player = null

func _on_collision_body_entered(body):
	if body.has_method("drop_oxygen"):
		body.drop_oxygen(40)

func freeze():
	if is_frozen:
		return  # Avoid stacking freezes
	is_frozen = true
	bubble_overlay.visible = true  # Show the bubble sprite

	# Wait for 1 second before unfreezing
	await get_tree().create_timer(1.0).timeout
	is_frozen = false
	bubble_overlay.visible = false  # Hide the bubble sprite

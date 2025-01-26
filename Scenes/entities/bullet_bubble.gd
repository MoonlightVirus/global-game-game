extends RigidBody2D

@export var speed = 750           # Initial speed of the bullet
@export var acceleration = 500   # Acceleration rate of the bullet
@export var lifetime = 2.0       # The lifetime of the bullet in seconds
@export var bubble_overlay = preload("res://Scenes/entities/bubble_overlay.tscn")  # Overlay bubble scene

func _ready():
	# Schedule the bullet to disappear after `lifetime` seconds
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	# Increase the speed over time with acceleration
	speed += acceleration * delta
	# Move the bullet in the direction of its local x-axis
	linear_velocity = transform.x * speed

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemy"):
		# Create the bubble overlay and attach it to the enemy
		if bubble_overlay:
			var overlay = bubble_overlay.instantiate()  # Create an instance of the bubble overlay
			body.add_child(overlay)  # Attach it to the enemy
			overlay.position = Vector2.ZERO  # Position it relative to the enemy
			overlay.start_effect()  # Start the overlay effect

		# Destroy the bubble projectile
		queue_free()

extends RigidBody2D

@export var speed = 750           # Initial speed of the bullet
@export var acceleration = 500   # Acceleration rate of the bullet
@export var lifetime = 2.0       # The lifetime of the bullet in seconds

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
	# Remove the bullet upon collision with any object
	queue_free()

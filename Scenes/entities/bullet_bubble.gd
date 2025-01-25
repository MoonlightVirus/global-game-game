extends Area2D

@export var speed = 550
@export var lifetime = 3.0 # The lifetime of the bullet in seconds

func _ready():
	# Schedule the bullet to disappear after `lifetime` seconds
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	queue_free()

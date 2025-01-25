extends CharacterBody2D

var bullet_bubble = preload("res://Scenes/entities/bullet_bubble.tscn")

@export var speed = 400
@export var smooth_factor = 2.0  # Higher values make the smoothing faster

@export var rotation_speed = 2.5 # Higher value means faster rotation
@export var rotation_offset = 0 # Offset angle in radians
@export var min_mouse_distance = 40.0  # Minimum distance to affect rotation

# Preload the scene


func _ready():
	# Instantiate the bullet bubble
	
	var instance = bullet_bubble.instantiate()
	
	# Add the instance to the scene tree
	add_child(instance)
	
	# Set the collision layers
	instance.collision_layer = (1 << 6) | (1 << 7)  # Binary: 11000000 (layers 7 and 8)
	
	# Alternatively, use set_collision_layer_bit
	instance.collision_layer = (1 << 6) | (1 << 7)  # Set layers 7 and 8
	instance.collision_mask = (1 << 6) | (1 << 7)  # Set mask for layers 7 and 8
func smooth_look_at(target_position, delta):
	# Calculate the distance to the target
	var distance_to_target = global_position.distance_to(target_position)

	# Only update rotation if the mouse is farther than the minimum distance
	if distance_to_target > min_mouse_distance:
		var target_angle = (target_position - global_position).angle() + rotation_offset
		rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

func shoot():
	var b = bullet_bubble.instantiate()
	owner.add_child(b)
	b.transform = $Lantern.global_transform
	
	# Set bullet's velocity based on player's facing direction
	var direction = Vector2(cos($Lantern.rotation), sin($Lantern.rotation))  # Direction the player is facing
	var speed = 400  # Example speed
	
	if b is RigidBody2D:
		b.linear_velocity = direction * speed  # Apply velocity to bullet

		# Set up collision layers and masks (set the bullet to interact with layers 7 and 8)
		b.collision_layer = 1 << 7  # Set the collision layer to layer 7
		b.collision_mask = (1 << 7) | (1 << 8)  # Set the mask to detect layers 7 and 8
		
		# Set the mode to Dynamic (in Godot 4.x)

func get_input(delta):

	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var target_velocity = input_direction * speed
	# Smoothly interpolate velocity towards the target velocity
	velocity = velocity.lerp(target_velocity, smooth_factor * delta)

func _physics_process(delta):
	smooth_look_at(get_global_mouse_position(), delta)
	get_input(delta)
	move_and_slide()

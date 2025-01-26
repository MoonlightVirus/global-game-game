extends CharacterBody2D

var bullet_bubble = load("res://Scenes/entities/bullet_bubble.tscn")

@export var speed = 250
@export var smooth_factor = 2.0
@export var rotation_speed = 2.5 
@export var rotation_offset = 0
@export var min_mouse_distance = 40.0

# Oxygen Bar
var oxygen = 100
@onready var oxygen_timer = $"../Timer"
@onready var progress = $"../CanvasLayer/ProgressBar"

# For smooth progress bar updates
var target_oxygen = 100
var oxygen_update_speed = 50.0 # Speed of the oxygen bar update per second

func _ready():
	# Instantiate the bullet bubble
	oxygen_timer.wait_time = 4.0
	oxygen_timer.one_shot = false
	oxygen_timer.start()
	oxygen_timer.timeout.connect(self.natural_oxygen_drop)
	
	var instance = bullet_bubble.instantiate()
	
	# Add the instance to the scene tree
	add_child(instance)
	
	# Set the collision layers
	instance.collision_layer = (1 << 6) | (1 << 7)  # Binary: 11000000 (layers 7 and 😎
	
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

func add_oxygen(hit_points):
	target_oxygen = min(oxygen + hit_points, 100)

func natural_oxygen_drop():
	if oxygen > 0:
		target_oxygen = max(oxygen - 5, 0)
	if target_oxygen <= 0:
		die()

func oxygen_drop(hit_points):
	if oxygen > 0:
		target_oxygen = max(oxygen - hit_points, 0)
	if target_oxygen <= 0:
		die()


func die():
	# Logic for player death
	velocity = Vector2.ZERO
	set_process_input(false)
	set_physics_process(false)
	get_tree().change_scene_to_file("res://Scenes/levels/game_over.tscn")


func _process(delta):
	# Smoothly update oxygen bar
	if abs(oxygen - target_oxygen) > 0.1:
		var step = oxygen_update_speed * delta
		if oxygen < target_oxygen:
			oxygen = min(oxygen + step, target_oxygen)
		elif oxygen > target_oxygen:
			oxygen = max(oxygen - step, target_oxygen)
		progress.value = oxygen

func shoot():
	var b = bullet_bubble.instantiate()
	owner.add_child(b)
	b.transform = $Lantern.global_transform
	
	# Set bullet's velocity based on player's facing direction
	var direction = Vector2(cos($Lantern.rotation), sin($Lantern.rotation))  # Direction the player is facing
	
	if b is RigidBody2D:
		b.linear_velocity = direction * speed  # Apply velocity to bullet

		# Set up collision layers and masks (set the bullet to interact with layers 7 and 8
		b.collision_layer = 1 << 7  # Set the collision layer to layer 7
		b.collision_mask = (1 << 7) | (1 << 8)  # Set the mask to detect layers 7 and 8
		
		# Set the mode to Dynamic (in Godot 4.x)

func get_input(delta):
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		shoot()
		oxygen_drop(1.5)
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var target_velocity = input_direction * speed
	# Smoothly interpolate velocity towards the target velocity
	velocity = velocity.lerp(target_velocity, smooth_factor * delta)

func _physics_process(delta):
	smooth_look_at(get_global_mouse_position(), delta)
	get_input(delta)
	move_and_slide()

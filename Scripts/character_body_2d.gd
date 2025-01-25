extends CharacterBody2D

var bullet_bubble = load("res://Scenes/entities/bullet_bubble.tscn")

@export var speed = 250

# Oxygen Bar
var oxygen = 100
@onready var oxygen_timer = $"../Timer"
@onready var progress = $"../CanvasLayer/ProgressBar"

# For smooth progress bar updates
var target_oxygen = 100
var oxygen_update_speed = 50.0 # Speed of the oxygen bar update per second

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

func _ready() -> void:
	oxygen_timer.wait_time = 4.0
	oxygen_timer.one_shot = false
	oxygen_timer.start()
	oxygen_timer.timeout.connect(self.natural_oxygen_drop)

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

func get_input():
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		shoot()
		oxygen_drop(1.5)
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()

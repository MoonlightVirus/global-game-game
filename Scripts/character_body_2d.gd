extends CharacterBody2D

var bullet_bubble = load("res://Scenes/entities/bullet_bubble.tscn")

@export var speed = 400

func shoot():
	var b = bullet_bubble.instantiate()
	owner.add_child(b)
	b.transform = $Lantern.global_transform
	
func get_input():
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		shoot()	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	

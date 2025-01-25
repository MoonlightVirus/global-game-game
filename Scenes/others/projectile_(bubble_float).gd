extends RigidBody3D


# Called when the node enters the scene tree for the first time.

var speed = 12.0  
var upward_force = 0.2
var lifetime = 5
var initial_velocity: Vector3 = Vector3.ZERO
var target_velocity: Vector3 = Vector3.ZERO
var acceleration = 0.2

func _ready() -> void:
	linear_velocity = initial_velocity + (transform.basis.z * -speed) + Vector3(0, upward_force, 0)
	await get_tree().create_timer(lifetime).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var velocity_diff = target_velocity - linear_velocity
	var acceleration_step = velocity_diff.normalized() * acceleration * state.step
	linear_velocity.y += upward_force

	if velocity_diff.length() < acceleration_step.length():
		linear_velocity = target_velocity
	else:
		linear_velocity += acceleration_step
	
	

extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	collision_layer = (1 << 6)  # Make sure it's on a dedicated layer
	collision_mask = (1 << 6)   # It can interact with other objects on this layer
	

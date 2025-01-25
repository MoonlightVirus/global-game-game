extends Node3D

@export var bubble_detection_walls: Area3D  # Reference to the child node with bubble_count
@export var bubble_goal: int = 20  # Threshold for bubble count
@export var target_y: float = 5.0  # Target y position for movement
@export var move_speed: float = 2  # Speed of movement

func _ready() -> void:
	if bubble_detection_walls == null:
		print("Error: bubble_detection_walls is NOT set.")
	else:
		print("Parent node is ready and bubble_detection_walls is set.")

func _process(delta: float) -> void:
	# Ensure bubble_detection_walls is not null before accessing it
	if bubble_detection_walls != null:
		# Print current bubble count for debugging
		print("Current bubble count: ", bubble_detection_walls.bubble_count)

		# Check if bubble_count exceeds or matches the goal
		if bubble_detection_walls.bubble_count >= bubble_goal:
			print("Goal reached. Taking action!")
			take_action(delta)

func take_action(delta: float) -> void:
	# Move towards the target_y position
	if self.position.y < target_y:
		self.position.y += move_speed * delta
		# Clamp the position to ensure it doesn't overshoot
		self.position.y = min(self.position.y, target_y)
		print("Moving up. Current y position: ", self.position.y)
	else:
		print("Target y position reached.")

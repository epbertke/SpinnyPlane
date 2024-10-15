extends Area2D

var speed: float = 250

func _ready() -> void:
	print("Rock script ready")
	# Connect the signal directly to the _on_body_entered method in this instance
	connect("body_entered", Callable(self, "_on_body_entered"))
	print("Signal connected")

func _physics_process(delta: float) -> void:
	position.x -= speed * delta

func _on_body_entered(body: Node2D) -> void:  # Ensure the plane is in the correct group
		# Directly call the method in the controller
	var controller = get_parent().get_node("/root/FlappyController")
	if controller:
		controller.plane_hit()  # Call the plane hit method
		print("Plane hit called")
	else:
		print("Controller node not found!")

	queue_free()  # Remove the rock after collision

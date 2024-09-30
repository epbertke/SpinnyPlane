class_name Rock extends Area2D
var plane = preload("res://plane.tscn")

func _physics_process(delta: float):
	position.x -= 120.0 * delta
	if position.x < -40:
		queue_free()

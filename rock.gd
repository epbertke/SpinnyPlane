extends Area2D


var speed : float = 250

func _process(delta: float) -> void:
	position.x -= speed * delta

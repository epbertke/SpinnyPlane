class_name Airplane extends RigidBody2D
var scroll_base_offset = Vector2.ZERO
@onready var animation = get_node("AnimatedSprite2D")

func _process(delta):
	scroll_base_offset.x -= 3
	
func _ready():
	fly()
	lock_rotation = true
	can_sleep = false
	
func _integrate_forces(delta):
	#Clamps plane position s/t it can't go so low/high that
		#it goes around the rocks
	var screen_size = get_viewport().size + Vector2i(0, 40)
	position.y = clamp(position.y, -40, screen_size.y)
	#jumps and does flap animation when spacebar is pressed
	if Input.is_action_just_pressed("flap"):
		jump()

func fly():
	animation.play("glide")

func jump():
	$"../sfx/flap".play()
	animation.play("flap")
	set_axis_velocity(Vector2(0,-500))

func _on_animated_sprite_2d_animation_finished():
	fly()

func _on_top_rock_body_entered(body: Node2D):
	$"..".plane_hit()
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	$"..".plane_hit()
	queue_free()

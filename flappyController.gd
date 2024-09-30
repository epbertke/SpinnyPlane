extends Node2D
signal spawn(scene, location)
var timer
var label
var button
var animation
var top_rock = preload("res://top_rock.tscn")
var bottom_rock = preload("res://rock.tscn")
var plane = preload("res://plane.tscn")

func _ready():
	timer = $rock_timer
	label = $Control/GameOver
	button = $Control/Replay
	animation = $Control/AnimationPlayer
	
func spawn_rock():
	var rock_choice = randf() < .5
	if rock_choice:
		var rock_scene = $"Rock"
		var rock_instance = top_rock.instantiate()
		add_child(rock_instance)
		spawn.emit(rock_scene, Vector2())
	else:
		var rock_scene = $"Rock"
		var rock_instance = bottom_rock.instantiate()
		add_child(rock_instance)
		spawn.emit(rock_scene, Vector2())

func _on_rock_timer_timeout() -> void:
	spawn_rock()
		
func plane_hit():
	$sfx/thud.play()
	timer.stop()
	animation.get_queue()
	label.visible = true
	button.visible = true
	
func _on_replay_pressed():
	label.visible = false
	button.visible = false
	timer.start()
	spawn_new_plane()
	
func spawn_new_plane():
	var plane_scene = $"Airplane"
	var new_plane = plane.instantiate()
	add_child(new_plane)
	spawn.emit(plane_scene, Vector2())
	
	

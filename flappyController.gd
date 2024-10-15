extends Node2D
signal spawn(scene, location)

var timer
var label
var button
var animation
var plane = preload("res://plane.tscn")
var plane2
var sfx 
var thud  # Track the currently active plane
var plane_active = false  
var current_plane # Flag to check if a plane is active

var rock_resources = [
	preload("res://TestBottomRock.tscn"),
	preload("res://testRockTestTop.tscn")
]

var top_spawn_locations = [Vector2(1274, 113), Vector2(1509, 113), Vector2(1905, 113)]
var top_location_flag = 0

var bottom_spawn_locations = [Vector2(1274, 550), Vector2(1509, 550), Vector2(1905, 550)]
var bottom_location_flag = 0

func _ready():
	# Get the SpinnyPlane node first
	var spinny_plane = get_node("/root/spinnyplane")
	plane2 = get_node("/root/spinnyplane/plane")
	if spinny_plane == null:
		print("SpinnyPlane not found! Please check the path.")
		return  # Exit if the node is not found

	# Now access the Control node
	var control = spinny_plane.get_node("Control")
	if control == null:
		print("Control not found! Please check the path.")
		return

	# Access the rock_timer from SpinnyPlane
	timer = spinny_plane.get_node("rock_timer")
	if timer == null:
		print("Timer not found! Please check the path.")
	else:
		timer.timeout.connect(_on_rock_timer_timeout)
		timer.start()

	# Access the GameOver label and Replay button
	label = control.get_node("GameOver")
	if label == null:
		print("GameOver label not found! Please check the path.")
	else:
		print("GameOver label found:", label)

	button = control.get_node("Replay")  # Ensure this path is correct
	if button == null:
		print("Replay button not found! Please check the path.")
	else:
		print("Replay button found:", button)

	animation = control.get_node("AnimationPlayer")  # Ensure this path is correct
	if animation == null:
		print("AnimationPlayer not found! Please check the path.")
	else:
		print("AnimationPlayer found:", animation)
	
	# Initialize SFX
	sfx = spinny_plane.get_node("sfx")  # Adjust the path according to your structure
	if sfx == null:
		print("SFX node not found!")
		return

	# Access the thud audio stream player
	thud = sfx.get_node("thud")  # Assuming 'thud' is an AudioStreamPlayer
	if thud == null:
		print("Thud sound effect not found!")
		return

func spawn_rock():
	var random = randf() < 0.5
	var rock_instance
	var spawn_location
	if random:
		rock_instance = rock_resources[1].instantiate()
		spawn_location = get_spawn_location("top")
		print("Spawning top rock at: ", spawn_location)
	else:
		rock_instance = rock_resources[0].instantiate()
		spawn_location = get_spawn_location("bottom")
		print("Spawning bottom rock at: ", spawn_location)

	add_child(rock_instance)
	rock_instance.position = spawn_location
	print("Rock instance:", rock_instance, "at position:", spawn_location)

func _on_rock_timer_timeout() -> void:
	spawn_rock()
	timer.start()

func plane_hit():
	print("Plane Hit Function")
	if thud:
		thud.play()
	else:
		print("Thud is null, cannot play sound.")

	timer.stop()
	
	if plane2:  # Check if the current plane instance exists
		print("Removing plane:", plane2)
		plane2.queue_free()  # Remove the current plane
		plane_active = false
		plane2 = null  # Clear the reference to the removed plane
		print("Plane removed.")
	else:
		print("No plane to remove.")
	
	if animation:
		animation.play("slide_in")  # Replace with the actual name of your animation
	else:
		print("Animation player is null!")

	label.visible = true
	button.visible = true

func _on_replay_pressed():
	label.visible = false
	button.visible = false
	spawn_new_plane()
	timer.start()

func spawn_new_plane():
	if plane_active:
		print("Plane is already active, not spawning another.")
		return

	print("Spawning a new plane...")
	plane2 = plane.instantiate()
	add_child(plane2)
	plane_active = true
	print("Plane instance:", plane2)
	emit_signal("spawn", plane, plane2.position)  # Emit signal on spawn
	print("New plane spawned:", plane2)

func get_spawn_location(random_choice):
	if random_choice == "top":
		if top_location_flag == 0:
			return top_spawn_locations[0]
		if top_location_flag == 1:
			return top_spawn_locations[1]
		if top_location_flag == 2:
			return top_spawn_locations[2]
		top_location_flag += 1
		if top_location_flag > 2:
			top_location_flag = 0
	if random_choice == "bottom":
		if bottom_location_flag == 0:
			return bottom_spawn_locations[0]
		if bottom_location_flag == 1:
			return bottom_spawn_locations[1]
		if bottom_location_flag == 2:
			return bottom_spawn_locations[2]
		bottom_location_flag += 1
		if bottom_location_flag > 2:
			bottom_location_flag = 0

extends AnimationPlayer
var game_over_label : Label

func _ready():
	game_over_label = $"../GameOver"
	game_over_label.position.y = -33

func _process(delta):
	if(game_over_label.position.y < 137):
		game_over_label.position.y += 50 * delta
	

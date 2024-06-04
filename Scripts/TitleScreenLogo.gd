extends Control

var tween

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func animate():
	if tween:
		tween.kill()
	tween = create_tween().bind_node(self)
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.04)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.08)

func _on_conductor_beat(_beatPosition):
	animate()

func _on_game_start():
	animate()
	

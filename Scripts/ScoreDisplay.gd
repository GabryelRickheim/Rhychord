extends Label

var tween

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_conductor_beat(_beatPosition):
	animate()
	
func animate():
	if tween:
		tween.kill()
	tween = create_tween().bind_node(self)
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.02)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.04)

extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_conductor_beat(_beatPosition):
	var tween = get_tree().create_tween()
	# increase the size of the circle using tween
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.04)
	#return to original size
	tween.tween_property(self, "scale", Vector2(1, 1), 0.04)

extends Label

# Script responsavel por animar elementos da interface, fazendo-os "pulsar" no ritmo da musica

var tween


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Funcao chamada pelo Conductor para animar o elemento
func _on_conductor_beat():
	_animate()


# Funcao que anima o elemento, fazendo-o "pulsar"
func _animate():
	if tween:
		tween.kill()
	tween = create_tween().bind_node(self)
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.02)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.04)

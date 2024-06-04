extends Control

#Script responsável por animar os elementos da tela de título

var tween


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Função que anima o elemento, fazendo ele "pulsar"
func _animate():
	if tween:
		tween.kill()
	tween = create_tween().bind_node(self)
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.04)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.08)


# Função que é chamada a cada batida do condutor
func _on_conductor_beat():
	_animate()


# Função que é chamada quando o jogador inicia o jogo
func on_game_start():
	_animate()

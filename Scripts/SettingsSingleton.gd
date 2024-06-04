extends Node

# Script responsável por armazenar as configurações do jogo
# Está sempre presente na cena raiz, e é acessado por outros scripts para atualizar as informações

var songVolume = -6  # Volume da música
var hitSoundVolume = -12  # Volume do som de acerto
var speedAdd = 256  # Velocidade adicional das notas


func _ready():
	pass


func _process(_delta):
	pass


# Função para redefinir as configurações do jogo
func reset():
	songVolume = -6
	hitSoundVolume = -12
	speedAdd = 256

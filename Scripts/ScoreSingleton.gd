extends Node

# Script responsável por armazenar as informações da partida atual
# Está sempre presente na cena raiz, e é acessado por outros scripts para atualizar as informações

# Variáveis que armazenam as informações da partida
var score = 99999  # Pontuação
var perfects = 999  # Quantidade de acertos perfeitos
var goods = 999  # Quantidade de acertos bons
var earlys = 999  # Quantidade de acertos adiantados
var lates = 999  # Quantidade de acertos atrasados
var misses = 0  # Quantidade de erros
var maxCombo = 999  # Maior combo
var percentage = 100  # Porcentagem de acertos
var rank = "SS"  # Rank da partida
var songName = "Ticking Village"  # Nome da música


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Função para redefinir as informações da partida
func reset():
	score = 0
	perfects = 0
	goods = 0
	earlys = 0
	lates = 0
	misses = 0
	percentage = 0
	rank = "F"
	songName = "Song Name Placeholder"

extends Area2D

# Script responsável por controlar o comportamento das notas

# Sinal emitido quando a nota é destruída
signal destroyed(index, hit)

# Variáveis
var bpm = 0  # Batidas por minuto da música
var speed = 0  # Velocidade base da nota
var hit = false  # Representa se a nota foi acertada ou não
var lane = 0  # Representa a direção da nota
var index = 0  # Representa a posição da nota na lista de notas
var speedAdd = 0  # Representa a velocidade adicional da nota


func _ready():
	pass


# Função que é chamada a cada quadro. Movimenta a nota em direção ao centro da tela
func _physics_process(delta):
	# Se a nota foi acertada, ela não se move
	if !hit:
		# Movimenta a nota na direção correta de acordo com a direção da nota
		# 0 = Esquerda, 1 = Cima, 2 = Direita, 3 = Baixo
		if lane == 0:
			position.x += speed * delta
		elif lane == 1:
			position.y += speed * delta
		elif lane == 2:
			position.x -= speed * delta
		elif lane == 3:
			position.y -= speed * delta
		else:
			$Node2D.position.y -= speed * delta


# Função responsavel por inicializar a nota com os valores passados pela fase principal
func initialize(laneArg, indexArg, startDelay, speedAddArg):
	self.lane = laneArg
	self.index = indexArg
	self.speedAdd = speedAddArg
	# Define a velocidade da nota de acordo com a velocidade base e a velocidade adicional
	speed = ((384 + speedAdd) / startDelay)
	# Define a posição inicial da nota de acordo com a direção da nota
	# 0 = Esquerda, 1 = Cima, 2 = Direita, 3 = Baixo
	if laneArg == 0:
		$AnimatedSprite2D.frame = 0
		position.x = -72 - speedAdd
		position.y = 384
	elif laneArg == 1:
		$AnimatedSprite2D.frame = 1
		position.x = 384
		position.y = -72 - speedAdd
	elif laneArg == 2:
		$AnimatedSprite2D.frame = 2
		position.x = 768 + 72 + speedAdd
		position.y = 384
	elif laneArg == 3:
		$AnimatedSprite2D.frame = 3
		position.x = 384
		position.y = 768 + 72 + speedAdd
	else:
		printerr("Invalid laneArg set for note: " + str(laneArg))
		return


# Função que é chamada quando a nota é destruída
func destroy():
	# Emite o sinal de destruição da nota e a deixa invisível
	$AnimatedSprite2D.visible = false
	emit_signal("destroyed", index, hit)
	# Se a nota foi acertada, ela emite partículas e é destruída após um tempo
	# Se não, ela é destruída imediatamente
	if hit:
		$GPUParticles2D.emitting = true
		$Timer.start()
	else:
		queue_free()


# Função que é chamada quando o timer é finalizado (após a destrição da nota)
func _on_timer_timeout():
	queue_free()

extends Area2D

# Botão que o jogador deve pressionar para acertar as notas

# Lista de notas que estão sobrepondo o botão
var notes = []
# Lista de entradas possíveis
var inputs = ["left", "up", "right", "down"]
# Tween para animação do botão
var tween
# Variavel que registra se o botão está sendo segurado
var isHeld

# Variavel que define a entrada que o botão representa
@export var input = ""

func _process(_delta):
	if notes:
		var note = notes[0]
		if note.type == 1 and !note.hit and isHeld:
			# Remove a nota da lista e marca como acertada
			notes.erase(note)
			note.hit = true
			note.destroy()
			# Inicia a animação do botão
			animate()


# Função que lida com eventos de entrada não tratados
# [param event]: O evento de entrada não tratado
func _unhandled_input(event):
	# Verifica se o evento corresponde à ação de entrada do botão
	if event.is_action("ui_" + input):
		# Verifica se o evento é de pressionar o botão
		if event.is_action_pressed("ui_" + input):
			# Acende o botão, indicando que está pressionado
			$AnimatedSprite2D.frame = 1
			# Verifica se há notas sobrepondo o botão
			if !notes.is_empty():
				# Encontra a nota mais antiga
				var note = notes[0]
				# Remove a nota da lista e marca como acertada
				notes.erase(note)
				note.hit = true
				note.destroy()
				# Inicia a animação do botão
				animate()
				isHeld = true
		# Verifica se o botão foi solto
		elif event.is_action_released("ui_" + input):
			# Apaga o botão, indicando que não está pressionado
			$AnimatedSprite2D.frame = 0
			isHeld = false


# Função que anima o botão quando uma nota é acertada
func animate():
	# Cancela a animação anterior, se houver
	if tween:
		tween.kill()
	# Cria uma nova animação
	tween = create_tween()
	# Aumenta e diminui o botão rapidamente
	tween.tween_property($AnimatedSprite2D, "scale", Vector2(1.15, 1.15), 0.02)
	tween.tween_property($AnimatedSprite2D, "scale", Vector2(1, 1), 0.04)


# Função que redefine a lista de notas
func _reset():
	notes = []


# Função que é chamada quando uma nota entra na área do botão
# [param note]: A nota que entrou na área do botão
func _on_area_2d_area_entered(note):
	# Verifica se a nota corresponde à entrada do botão
	if note.lane == inputs.find(input):
		# Adiciona a nota à lista de notas
		notes.append(note)


# Função que é chamada quando uma nota sai da área do botão
# [param note]: A nota que saiu da área do botão
func _on_area_2d_area_exited(note):
	# Verifica se a nota não foi acertada e corresponde à entrada do botão
	if !note.hit and (note.lane == inputs.find(input)):
		# Remove a nota da lista de notas
		notes.erase(note)
		# Destroi a nota
		note.destroy()

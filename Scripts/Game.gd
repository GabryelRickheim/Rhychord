extends Node2D

# Script responsável por gerenciar a lógica da fase musical do jogo

# Variaveis responsaveis pela musica e notas
var songName = ""  # Nome da música
var bpm = 0  # Batidas por minuto da música
var secsPerBeat = 0  # Quantidade de segundos por batida
var startDelay = 0  # Atraso inicial para a primeira nota
var perfectTimingWindow = 0  # Janela de tempo para acertos perfeitos
var goodTimingWindow = 0  # Janela de tempo para acertos bons
var Note = preload("res://Scenes/Note.tscn")  # Cena da nota
var notes = []  # Lista de momentos em que as notas devem ser acertadas
var lanes = []  # Lista de direções das notas
var currentNote = 0  # Indice da próxima nota a ser gerada
var instance = null  # Instancia da nota a ser gerada

# Variaveis responsaveis pela pontuacao
var score = 0  # Pontuação do jogador
var notesHit = 0  # Quantidade de notas acertadas
var currentCombo = 0  # Combo atual do jogador
var maxCombo = 0  # Combo máximo do jogador
var perfects = 0  # Quantidade de acertos perfeitos
var goods = 0  # Quantidade de acertos bons
var earlys = 0  # Quantidade de acertos adiantados
var lates = 0  # Quantidade de acertos atrasados
var misses = 0  # Quantidade de erros
var currentPercentage = 100.0  # Porcentagem de acertos do jogador


# Função chamada quando o jogo e iniciado
# Inicializa a musica e o mapa das notes
func _ready():
	# Obtém o nome da música do objeto ScoreSingleton e atribui à variável songName
	songName = ScoreSingleton.songName
	# Realiza a transição de fade-in da tela de nível
	$LevelEndFade.color.a = 1
	var tween = self.create_tween()
	tween.tween_property($LevelEndFade, "color:a", 0, 0.5)
	# Obtém o caminho do arquivo de áudio e do mapa de notas com base no nome da música
	var songPath = "res://Charts/" + songName + "/song.ogg"
	var chartPath = "res://Charts/" + songName + "/chart.json"
	# Chama a função _build_chart passando o caminho do arquivo de mapa das notas como argumento
	_build_chart(chartPath)
	# Define o volume do áudio de acerto com base no volume definido no objeto SettingsSingleton
	$AudioStreamPlayer.volume_db = SettingsSingleton.hitSoundVolume
	# Inicializa o objeto Conductor com o caminho do arquivo de áudio, bpm e secsPerBeat
	$Conductor.initialize(songPath, bpm, secsPerBeat)
	# Inicia a reprodução do áudio com um deslocamento de batida de 1 segundo
	$Conductor.play_with_beat_offset(1)


# Funcão chamada a cada quadro
func _process(_delta):
	_spawn_notes()


# Função chamada quando a tecla escape é pressionada, responsável por pausar o jogo
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			if !get_tree().paused:
				$PauseMenu.visible = true
				$PauseMenu/VBoxContainer/ResumeButton.grab_focus()
				get_tree().paused = true


# Função responsável por gerar as notas, chamada a cada quadro
func _spawn_notes():
	# Verifica se ainda há notas a serem geradas
	if currentNote < (notes.size() - 1):
		# Verifica se a posição da música é maior ou igual à posição da próxima nota
		# Se verdadeiro, gera a próxima nota
		if $Conductor.songPosition >= notes[currentNote]:
			# Instancia um objeto de nota e inicializa seus atributos com base no mapa de notas
			instance = Note.instantiate()
			instance.initialize(
				lanes[currentNote],
				currentNote,
				startDelay,
				SettingsSingleton.speedAdd / (bpm / 138.0)
			)
			# Atualiza o índice da próxima nota
			currentNote += 1
			# Adiciona a nota como filho do nó atual
			add_child(instance)
			# Conecta o sinal da nota à função _on_note_destroy
			instance.connect("destroyed", _on_note_destroy)


# Esta função é responsável por construir o mapa de notas com base no arquivo JSON
# [param chartPath] O caminho do arquivo JSON contendo o mapa de notas
func _build_chart(chartPath):
	# Abre o arquivo JSON e extrai seu conteúdo como uma string
	var file = FileAccess.open(chartPath, FileAccess.READ)
	var contents = file.get_as_text()
	file.close()
	var json = JSON.parse_string(contents)

	# Extrai o momento em que a nota deve ser acertada e sua direção da string JSON
	for i in json[2]["chart"]:
		notes.append(i["note"])
		lanes.append(i["lane"])

	# Calcula janelas de tempo com base no BPM da música
	bpm = json[0]["bpm"]
	secsPerBeat = (60.0 / bpm)
	startDelay = (secsPerBeat * 3)
	perfectTimingWindow = (secsPerBeat / 12) * (bpm / 138)
	goodTimingWindow = (secsPerBeat / 8) * (bpm / 138)


# Função chamada quando uma nota é destruída.
# Responsável por calcular a pontuação do jogador e atualizar a interface do usuário
func _on_note_destroy(index, hit):
	# Verifica se a nota destruida foi acertada
	if hit:
		# Calcula a diferença entre o momento em que a nota foi acertada e o momento em que deveria ser acertada
		var adjustedSongPosition = $Conductor.songPosition - startDelay
		var offset = (notes[index] * -1) + adjustedSongPosition

		# Atualiza a quantidade de notas acertadas e o combo atual
		notesHit += 1
		currentCombo += 1
		$Control/ComboLabel.set_text("X" + str(currentCombo))
		# Atualiza o combo máximo se o combo atual for maior
		if currentCombo > maxCombo:
			maxCombo = currentCombo
		# Toca o áudio de acerto
		$AudioStreamPlayer.play()

		# Calcula a pontuação de acordo com o quão próximo o jogador acertou a nota em relação a musica
		# e atualiza a interface do usuário com base no resultado
		if offset < perfectTimingWindow && offset > (perfectTimingWindow * -1):
			$Control/JudgementLabel.set_text("Perfect!")
			score += 100
			perfects += 1
			$Control/ScoreLabel.set_text("%05d" % score)
		elif offset < goodTimingWindow && offset > (goodTimingWindow * -1):
			$Control/JudgementLabel.set_text("Good")
			score += 50
			goods += 1
			$Control/ScoreLabel.set_text("%05d" % score)
		elif offset >= perfectTimingWindow:
			$Control/JudgementLabel.set_text("Late")
			score += 25
			lates += 1
			$Control/ScoreLabel.set_text("%05d" % score)
		elif offset <= (perfectTimingWindow * -1):
			$Control/JudgementLabel.set_text("Early")
			score += 25
			earlys += 1
			$Control/ScoreLabel.set_text("%05d" % score)
	# Se a nota não foi acertada, atualiza a interface do usuário e interrompe o combo atual
	else:
		misses += 1
		currentCombo = 0
		$Control/ComboLabel.set_text("")
		$Control/JudgementLabel.set_text("Miss")

	# Calcula a porcentagem de acertos do jogador e atualiza a interface do usuário
	# O calculo é feito com base na quantidade de notas acertadas e a quantidade de notas no mapa
	# Acertos bons contam apenas 90% do valor de um acerto perfeito
	# Acertos adiantados ou atrasados contam apenas 70% do valor de um acerto perfeito
	currentPercentage = (
		(
			(notesHit - (goods * 0.1) - (earlys * 0.3) - (lates * 0.3))
			/ (index + 1.0)
		)
		* 100.0
	)
	$Control/PercentageLabel.set_text("%4.2f" % currentPercentage + "%")

	# Atualiza o rank do jogador com base na porcentagem de acertos
	if currentPercentage == 100:
		$Control/RankLabel.set_text("SS")
	elif currentPercentage >= 95:
		$Control/RankLabel.set_text("S")
	elif currentPercentage >= 90:
		$Control/RankLabel.set_text("A")
	elif currentPercentage >= 80:
		$Control/RankLabel.set_text("B")
	elif currentPercentage >= 70:
		$Control/RankLabel.set_text("C")
	elif currentPercentage >= 60:
		$Control/RankLabel.set_text("D")
	else:
		$Control/RankLabel.set_text("F")


# Função chamada quando o Conductor termina de tocar a música, simbolizando o fim do nível
func _on_conductor_finished():
	# Realiza a transição de fade-out da tela de nível
	var tween = self.create_tween()
	$LevelEndFade.color.a = 0
	tween.tween_property($LevelEndFade, "color:a", 1, 0.5)
	# Inicia um temporizador para chamar a função _on_level_end_timer_timeout após 0.5 segundos
	$LevelEndTimer.start()


# Função chamada quando o temporizador de fim de nível é encerrado,  responsavel por
# transferir a pontuação e o jogador para a tela de resultados
func _on_level_end_timer_timeout():
	ScoreSingleton.reset()
	ScoreSingleton.perfects = perfects
	ScoreSingleton.goods = goods
	ScoreSingleton.earlys = earlys
	ScoreSingleton.lates = lates
	ScoreSingleton.misses = misses
	ScoreSingleton.score = score
	ScoreSingleton.percentage = currentPercentage
	ScoreSingleton.maxCombo = maxCombo
	ScoreSingleton.rank = $Control/RankLabel.get_text()
	ScoreSingleton.songName = songName
	get_tree().change_scene_to_file("res://Scenes/ResultScreen.tscn")

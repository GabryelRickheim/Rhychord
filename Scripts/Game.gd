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
var types = []  # Lista dos tipos das notas
var currentNote = 0  # Indice da próxima nota a ser gerada
var instance = null  # Instancia da nota a ser gerada
var noteObjects = []  # Guarda as referencias das notas instanciadas

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
var noteCount = 0  # Quantidade de notas acertadas ou erradas


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
	var songPath = "./Charts/" + songName + "/song.ogg"
	var chartPath = "./Charts/" + songName + "/chart.json"
	# Chama a função _build_chart passando o caminho do arquivo de
	# mapa das notas como argumento
	if FileAccess.file_exists(chartPath):
		_build_chart(chartPath)
	else:
		_on_conductor_finished()
	# Define o volume do áudio de acerto com base no volume definido
	# no objeto SettingsSingleton
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
				self.set_process_unhandled_input(false)
				get_tree().paused = true


# Função responsável por ativar as notas, chamada a cada quadro
func _spawn_notes():
	# Verifica se ainda há notas a serem geradas
	if currentNote < (noteObjects.size() - 1):
		# Verifica se a posição da música é maior ou igual à posição da próxima nota
		# Se verdadeiro, gera a próxima nota
		if $Conductor.songPosition >= noteObjects[currentNote].time:
			# Ativa a nota atual
			noteObjects[currentNote].visible = true
			noteObjects[currentNote].process_mode = PROCESS_MODE_INHERIT
			# Atualiza o índice da próxima nota
			currentNote += 1


# Esta função é responsável por construir o mapa de notas com base no arquivo JSON
# [param chartPath] O caminho do arquivo JSON contendo o mapa de notas
func _build_chart(chartPath):
	# Abre o arquivo JSON e extrai seu conteúdo como uma string
	var file = FileAccess.open(chartPath, FileAccess.READ)
	var contents = file.get_as_text()
	file.close()
	var jsonInstance = JSON.new()
	var error = jsonInstance.parse(contents)
	if error != OK:
		_on_conductor_finished()
		return
	var json = JSON.parse_string(contents)

	# Extrai o momento em que a nota deve ser acertada e sua direção da string JSON
	# Também extrai se é do tipo seta ou trilha
	for i in json[1]["chart"]:
		notes.append(i["note"])
		lanes.append(i["lane"])
		types.append(i["type"])

	# Calcula janelas de tempo com base no BPM da música
	bpm = json[0]["bpm"]
	secsPerBeat = (60.0 / bpm)
	startDelay = (secsPerBeat * 3)
	perfectTimingWindow = (secsPerBeat / 20) * (bpm / 138)
	goodTimingWindow = (secsPerBeat / 10) * (bpm / 138)

	# Instancia os objetos de nota e inicializa seus atributos com
	# base no mapa de notas, e então adiciona-os na lista de notas
	for i in range(0, notes.size()):
		instance = Note.instantiate()
		instance.initialize(
			notes[i],
			lanes[i],
			i,
			startDelay,
			SettingsSingleton.speedAdd / (bpm / 138.0),
			types[i]
		)
		instance.visible = false
		instance.process_mode = PROCESS_MODE_DISABLED
		noteObjects.append(instance)
		# Salva as trilhas e as setas como filhos de nós diferentes
		# Caso contrário, trilhas renderizam sobre as setas
		if instance.type == 0:
			$NoteParent.add_child(instance)
		else:
			$TrailParent.add_child(instance)
			$TrailParent.move_child(instance, $TrailParent.get_child_count())
		# Conecta o sinal da nota à função _on_note_destroy
		instance.connect("destroyed", _on_note_destroy)


# Função chamada quando uma nota é destruída.
# Responsável por calcular a pontuação do jogador e atualizar a interface do usuário
func _on_note_destroy(index, hit, type):
	noteCount += 1
	# Verifica se a nota destruida foi acertada
	if hit:
		# Calcula a diferença entre o momento em que a nota foi acertada
		# e o momento em que deveria ser acertada
		var adjustedSongPosition = $Conductor.songPosition - startDelay
		var offset = (notes[index] * -1) + adjustedSongPosition

		# Atualiza a quantidade de notas acertadas e o combo atual
		notesHit += 1
		currentCombo += 1
		$Control/ComboLabel.set_text("X" + str(currentCombo))
		# Atualiza o combo máximo se o combo atual for maior
		if currentCombo > maxCombo:
			maxCombo = currentCombo
		# Toca o som de acerto, se a nota for do tipo seta
		if type == 0:
			$AudioStreamPlayer.play()
		# Calcula a pontuação de acordo com o quão próximo o jogador
		# acertou a nota em relação a musica
		# e atualiza a interface do usuário com base no resultado
		if type == 1:
			score += 10
			$Control/ScoreLabel.set_text("%05d" % score)
		elif (
			offset < perfectTimingWindow && offset > (perfectTimingWindow * -1)
		):
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
			(notesHit - (goods * 0.333) - (earlys * 0.75) - (lates * 0.75))
			/ noteCount
		)
		* 100.0
	)
	$Control/PercentageLabel.set_text("%4.2f" % currentPercentage + "%")

	# Atualiza o rank do jogador com base
	# na porcentagem de acertos
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

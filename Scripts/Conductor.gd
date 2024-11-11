extends AudioStreamPlayer

# Script responsável por controlar a posição atual da reprodução da música
# e emitir sinais ao ocorrerem batidas na música

# Sinais para emitir eventos de batida
signal beat

# Variáveis para controlar o ritmo da música
var bpm = 0  # BPM (batidas por minuto) da música
var songPosition = 0  # Posição atual da música em segundos
var songPositionInBeats = 0  # Posição atual da música em batidas
var secsPerBeat = 0  # Duração de cada batida em segundos
var lastReportedBeat = -1  # Última batida reportada
var beatsBeforeStart = 0  # Número de batidas antes do início da música


# Inicializa a posição da música
func _ready():
	songPosition = -1


# Função chamada a cada quadro para atualizar a posição da música
func _process(_delta):
	# Verifica se a música está sendo reproduzida
	if self.playing:
		# Atualiza a posição da música com base na posição de
		# reprodução e na latências do servidor de áudio e do dispositivo de saída
		songPosition = (
			get_playback_position() + AudioServer.get_time_since_last_mix()
		)
		songPosition -= AudioServer.get_output_latency()
		# Calcula a posição atual da música em batidas
		songPositionInBeats = (
			int(floor(songPosition / secsPerBeat)) + beatsBeforeStart
		)
		# Reporta a batida atual
		_report_beat()


# Função usada para reportar a que uma batida ocorreu e emitir o sinal
func _report_beat():
	# Verifica se a batida atual é diferente da última reportada
	if lastReportedBeat < songPositionInBeats:
		# Emite o sinal de batida e atualiza a última batida reportada para a atual
		emit_signal("beat")
		lastReportedBeat = songPositionInBeats


# Função para iniciar a reprodução da música depois de um número de batidas
# [param num]: Número de batidas antes do início da música
# Utiliza a função _on_StartTimer_timeout para iniciar a reprodução
func play_with_beat_offset(num):
	beatsBeforeStart = num
	# Define o tempo de espera do StartTimer como a duração de uma batida
	$StartTimer.wait_time = secsPerBeat
	$StartTimer.start()


# Função chamada quando ocorre o temporiador StartTimer é finalizado
func _on_StartTimer_timeout():
	_report_beat()  # Reporta a batida atual
	songPositionInBeats += 1  # Incrementa a posição da música em batidas

	# Verifica se a posição da música está antes do início da música
	if songPositionInBeats < beatsBeforeStart:
		$StartTimer.start()  # Inicia o timer novamente

	# Verifica se a posição da música está exatamente uma batida antes do início da música
	elif songPositionInBeats == beatsBeforeStart:
		# Reduz o tempo de espera do StartTimer com base na latência do servidor de áudio
		# e do dispositivo de saída
		$StartTimer.wait_time = (
			$StartTimer.wait_time
			- (
				AudioServer.get_time_to_next_mix()
				+ AudioServer.get_output_latency()
			)
		)
		$StartTimer.start()  # Inicia o timer novamente

	# Alcançou o início da música
	else:
		play()  # Inicia a reprodução da música
		$StartTimer.stop()  # Para o timer


# Função para carregar a música e definir o volume e as batidas por minuto
func initialize(songPathArg, bpmArg, secsPerBeatArg):
	var song
	if songPathArg.contains("res://"):
		song = load(songPathArg)
	else:
		song = AudioStreamOggVorbis.load_from_file(songPathArg)
	self.stream = song
	self.volume_db = SettingsSingleton.songVolume
	bpm = bpmArg
	secsPerBeat = secsPerBeatArg


# Função para definir o objeto
func reset():
	songPosition = -1
	songPositionInBeats = 0
	lastReportedBeat = -1
	beatsBeforeStart = 0

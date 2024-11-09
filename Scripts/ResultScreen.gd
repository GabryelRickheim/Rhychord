extends Node2D

# Script que controla a tela de resultados.

# Carrega a musica a tocar na tela de resultados. Por padrão, é a música de baixa pontuação.
var endSong = load("res://Sound/Low Score.mp3")
# Variável que indica se a tela de resultados terminou de ser exibida.
var finished = false
var newHighScore = false


# Exibe a tela de resultados lentamente em sincronia com a música.
func _ready():
	# Salva as informações da pontuação em um arquivo.
	var scorePath = "./Charts/" + ScoreSingleton.songName + "/score.txt"

	if FileAccess.file_exists(scorePath):
		var score_file = FileAccess.open(scorePath, FileAccess.READ)
		var json_data = score_file.get_as_text()
		var existing_score_data = {}
		if json_data != "":
			existing_score_data = JSON.parse_string(json_data)

		if ScoreSingleton.score > int(existing_score_data.get("score", 0)):
			newHighScore = true
			var new_score_data = {
				"song_name": ScoreSingleton.songName,
				"score": ScoreSingleton.score,
				"percentage": ScoreSingleton.percentage,
				"max_combo": ScoreSingleton.maxCombo,
				"perfects": ScoreSingleton.perfects,
				"goods": ScoreSingleton.goods,
				"earlys": ScoreSingleton.earlys,
				"lates": ScoreSingleton.lates,
				"misses": ScoreSingleton.misses,
				"rank": ScoreSingleton.rank
			}
			score_file.close()
			score_file = FileAccess.open(scorePath, FileAccess.WRITE)
			score_file.store_line(JSON.stringify(new_score_data))
		score_file.close()
	else:
		var score_file = FileAccess.open(scorePath, FileAccess.WRITE)
		var new_score_data = {
			"song_name": ScoreSingleton.songName,
			"score": ScoreSingleton.score,
			"percentage": ScoreSingleton.percentage,
			"max_combo": ScoreSingleton.maxCombo,
			"perfects": ScoreSingleton.perfects,
			"goods": ScoreSingleton.goods,
			"earlys": ScoreSingleton.earlys,
			"lates": ScoreSingleton.lates,
			"misses": ScoreSingleton.misses,
			"rank": ScoreSingleton.rank
		}
		score_file.store_line(JSON.stringify(new_score_data))
		score_file.close()

	# Toca a música de acordo com a pontuação.
	if ScoreSingleton.rank == "S" or ScoreSingleton.rank == "SS":
		endSong = load("res://Sound/Great Score!.mp3")
	elif ScoreSingleton.rank != "F" and ScoreSingleton.rank != "D":
		endSong = load("res://Sound/Good Score.mp3")
	$AudioStreamPlayer.stream = endSong
	$AudioStreamPlayer.volume_db = SettingsSingleton.songVolume
	$AudioStreamPlayer.play()

	# Faz a tela de resultados aparecer com um fade-in.
	$LevelEndFade.color.a = 1
	var tween = self.create_tween()
	tween.tween_property($LevelEndFade, "color:a", 0, 1.83)

	# Exibe as informações da música e da pontuação.
	$Control/SongNameLabel.set_text(ScoreSingleton.songName)
	tween.tween_property($Control/SongNameLabel, "visible_ratio", 1, 1.77)
	$Control/TotalScoreLabel.set_text(
		"Total Score: " + str(ScoreSingleton.score)
	)
	tween.tween_property($Control/TotalScoreLabel, "visible_ratio", 1, 1.77)
	$Control/TotalPercentageLabel.set_text(
		"Percentage: " + "%4.2f" % ScoreSingleton.percentage + "%"
	)
	tween.tween_property(
		$Control/TotalPercentageLabel, "visible_ratio", 1, 1.77
	)

	# Exibe as informações de precisão de acertos.
	$Control/TotalJudgementLabel.set_text(
		(
			"Max Combo: X"
			+ str(ScoreSingleton.maxCombo)
			+ "\n"
			+ "Perfect: "
			+ str(ScoreSingleton.perfects)
			+ "\n"
			+ "Good: "
			+ str(ScoreSingleton.goods)
			+ "\n"
			+ "Early: "
			+ str(ScoreSingleton.earlys)
			+ "\n"
			+ "Late: "
			+ str(ScoreSingleton.lates)
			+ "\n"
			+ "Miss: "
			+ str(ScoreSingleton.misses)
		)
	)
	tween.tween_property($Control/TotalJudgementLabel, "visible_ratio", 1, 1.75)

	# Deixa a tela branca por um instante e exibe a classificação do jogador.
	tween.tween_property($LevelEndFlash, "color:a", 1, 0.2)
	if ScoreSingleton.rank == "SS":
		tween.tween_property($Control/SSRankLabel, "visible", true, 0)
	else:
		$Control/FinalRankLabel.set_text(ScoreSingleton.rank)
		tween.tween_property($Control/FinalRankLabel, "visible", true, 0)
	if ScoreSingleton.misses == 0:
		tween.tween_property($Control/FullComboLabel, "visible", true, 0)
	elif ScoreSingleton.misses == 1:
		$Control/FullComboLabel.set_text("Nice Choke!")
		tween.tween_property($Control/FullComboLabel, "visible", true, 0)
	if newHighScore:
		tween.tween_property($Control/NewHighScoreLabel, "visible", true, 0)
	tween.tween_property($LevelEndFlash, "color:a", 0, 0.2)
	# Atualiza a variável 'finished' para permitir que o jogador saia da tela de resultados.
	tween.tween_callback(self._set_finished)


func _set_finished():
	finished = true


# Função que é executada a cada quadro.
# Sai da tela de resultados ao pressionar o botão de aceitar ou cancelar.
func _process(_delta):
	if (
		(Input.is_action_just_pressed("ui_accept") and finished)
		or Input.is_action_just_pressed("ui_cancel")
	):
		get_tree().change_scene_to_file("res://Scenes/SongSelect.tscn")

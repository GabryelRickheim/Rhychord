extends Node2D

var endSong = load("res://Sound/Low Score.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	if ScoreSingleton.rank == "S" or ScoreSingleton.rank == "SS":
		endSong = load("res://Sound/Great Score!.mp3")
	elif ScoreSingleton.rank != "F" and ScoreSingleton.rank != "D":
		endSong = load("res://Sound/Good Score.mp3")
	$AudioStreamPlayer.stream = endSong
	$AudioStreamPlayer.volume_db = SettingsSingleton.songVolume
	$AudioStreamPlayer.play()
	$LevelEndFade.color.a = 1
	var tween = self.create_tween()
	tween.tween_property($LevelEndFade, "color:a", 0, 1.83)
	$Control/SongNameLabel.set_text(ScoreSingleton.songName)
	tween.tween_property($Control/SongNameLabel, "visible_ratio", 1, (1.77))
	$Control/TotalScoreLabel.set_text("Total Score: " + str(ScoreSingleton.score))
	tween.tween_property($Control/TotalScoreLabel, "visible_ratio", 1, (1.77))
	$Control/TotalPercentageLabel.set_text("Percentage: " + "%4.2f" % ScoreSingleton.percentage + "%")
	tween.tween_property($Control/TotalPercentageLabel, "visible_ratio", 1, (1.77))
	$Control/TotalJudgementLabel.set_text(
		"Max Combo: X" + str(ScoreSingleton.maxCombo) + "\n" +
		"Perfect: " + str(ScoreSingleton.perfects) + "\n" +
		"Good: " + str(ScoreSingleton.goods) + "\n" +
		"Early: " + str(ScoreSingleton.earlys) + "\n" +
		"Late: " + str(ScoreSingleton.lates) + "\n" +
		"Miss: " + str(ScoreSingleton.misses))
	tween.tween_property($Control/TotalJudgementLabel, "visible_ratio", 1, (1.75))
	tween.tween_property($LevelEndFlash, "color:a", 1, 0.2)
	if ScoreSingleton.rank == "SS":
		tween.tween_property($Control/SSRankLabel, "visible", true, 0)
	else:
		$Control/FinalRankLabel.set_text(ScoreSingleton.rank)
		tween.tween_property($Control/FinalRankLabel, "visible", true, 0)
	if ScoreSingleton.misses == 0:
		tween.tween_property($Control/FullComboLabel, "visible", true, 0)
	tween.tween_property($LevelEndFlash, "color:a", 0, 0.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Scenes/SongSelect.tscn")


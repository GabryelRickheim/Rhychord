extends Node2D

var songName = ""
var bpm = 0
var beatsPerBar = 0
var secsPerBeat = 0
var startDelay = 0
var perfectTimingWindow = 0
var goodTimingWindow = 0
var note = preload("res://Scenes/Note.tscn")
var notes = []
var lanes = []
var currentNote = 0
var instance = null

var score = 0
var notesHit = 0
var currentCombo = 0
var maxCombo = 0
var perfects = 0
var goods = 0
var earlys = 0
var lates = 0
var misses = 0
var currentPercentage = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	songName = ScoreSingleton.songName
	$LevelEndFade.color.a = 1
	var tween = self.create_tween()
	tween.tween_property($LevelEndFade, "color:a", 0, 0.5)
	var songPath = "res://Charts/" + songName + "/song.ogg"
	var chartPath = "res://Charts/" + songName + "/chart.json"
	_build_chart(chartPath)
	$AudioStreamPlayer.volume_db = SettingsSingleton.hitSoundVolume
	$Conductor.stream = load(songPath)
	$Conductor.volume_db = SettingsSingleton.songVolume
	$Conductor.bpm = bpm
	$Conductor.beatsPerBar = beatsPerBar
	$Conductor.secsPerBeat = secsPerBeat
	$Conductor.play_with_beat_offset(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):		
	_spawn_notes()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			if !get_tree().paused:
				$PauseMenu.visible = true
				$PauseMenu/VBoxContainer/ResumeButton.grab_focus()
				get_tree().paused = true
				
		
func _spawn_notes():
	if currentNote < (notes.size() - 1):
		if $Conductor.songPosition >= notes[currentNote]:
			instance = note.instantiate()
			instance.initialize(lanes[currentNote], currentNote, startDelay, (SettingsSingleton.speedAdd / (bpm / 138.0)))
			currentNote += 1
			add_child(instance)
			instance.connect("destroyed", _on_note_destroy)

func _build_chart(chartPath):
	var file = FileAccess.open(chartPath, FileAccess.READ)
	var contents = file.get_as_text()
	file.close()
	var json = JSON.parse_string(contents)
	for i in json[2]["chart"]:
		notes.append(i["note"])
		lanes.append(i["lane"])
	bpm = json[0]["bpm"]
	beatsPerBar = json[1]["beatsPerBar"]
	secsPerBeat = (60.0 / bpm)
	startDelay = (secsPerBeat * 3)
	perfectTimingWindow = (secsPerBeat / 12) * (bpm / 138)
	goodTimingWindow = (secsPerBeat / 8) * (bpm / 138)
		
func _on_note_destroy(index, hit):	
	var adjustedSongPosition = $Conductor.songPosition - startDelay
	var offset = (notes[index] * -1) + adjustedSongPosition
	if hit:
		notesHit += 1
		currentCombo += 1
		if currentCombo > maxCombo:
			maxCombo = currentCombo
		$Control/ComboLabel.set_text("X" + str(currentCombo))
		$AudioStreamPlayer.play()
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
	else:
		misses += 1
		currentCombo = 0
		print("miss")
		$Control/ComboLabel.set_text("")
		$Control/JudgementLabel.set_text("Miss")
	currentPercentage = ((notesHit - (goods * 0.1) - (earlys * 0.3) - (lates * 0.3)) / (index + 1.0)) * 100.0
	$Control/PercentageLabel.set_text("%4.2f" % currentPercentage + "%")
	
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

func _on_conductor_finished():
	var tween = self.create_tween()
	$LevelEndFade.color.a = 0
	tween.tween_property($LevelEndFade, "color:a", 1, 0.5)
	$LevelEndTimer.start()


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

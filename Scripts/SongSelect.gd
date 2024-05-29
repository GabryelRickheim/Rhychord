extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$LevelEndFade.color.a = 1
	$Conductor.bpm = 120
	$Conductor.beatsPerBar = 4
	$Conductor.secsPerBeat = (60.0 / 120)
	$Conductor.volume_db = SettingsSingleton.songVolume
	$Conductor.play()
	var tween = self.create_tween()
	tween.tween_property($LevelEndFade, "color:a", 0, 0.35)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_conductor_finished():
	$Conductor.reset()
	$Conductor.play()


func _on_ssd_select_button_pressed():
	ScoreSingleton.songName = "Sound-Speed Dash"
	_load_main_game()

func _on_dtmn_select_button_pressed():
	ScoreSingleton.songName = "Determination"
	_load_main_game()
	
func _load_main_game():
	var tween = self.create_tween()
	tween.tween_property($LevelEndFade, "color:a", 1, 0.35)
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")

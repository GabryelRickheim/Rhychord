extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$LevelEndFade.color.a = 1
	$Conductor.bpm = 60
	$Conductor.beatsPerBar = 4
	$Conductor.secsPerBeat = (60.0 / 60)
	$Conductor.volume_db = SettingsSingleton.songVolume
	$Conductor.play()
	var tween = self.create_tween()
	tween.tween_property($LevelEndFade, "color:a", 0, 0.35)
	
func _on_conductor_finished():
	$Conductor.reset()
	$Conductor.play()

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
		elif event.pressed and event.keycode == KEY_SPACE:
			$Conductor.stop()
			$TextureRect._on_game_start()
			$Label._on_game_start()
			$SelectSFX.play()
			set_process_unhandled_input(false)
			var tween = self.create_tween()
			tween.tween_property($LevelEndFade, "color:a", 1, 1.57)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_audio_stream_player_finished():
	get_tree().change_scene_to_file("res://Scenes/SongSelect.tscn")

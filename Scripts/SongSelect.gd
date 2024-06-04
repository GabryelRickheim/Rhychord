extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$LevelEndFade.color.a = 1
	$Conductor.bpm = 120
	$Conductor.beatsPerBar = 4
	$Conductor.secsPerBeat = (60.0 / 120)
	$Conductor.volume_db = SettingsSingleton.songVolume
	$Conductor.play()
	$Control/VBoxContainer/TUTSelectButton.grab_focus()
	var tween = self.create_tween()
	tween.tween_property($LevelEndFade, "color:a", 0, 0.35)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_conductor_finished():
	$Conductor.reset()
	$Conductor.play()

func _on_ssd_select_button_pressed():
	_load_main_game("Sound-Speed Dash")

func _on_dtmn_select_button_pressed():
	_load_main_game("Determination")

func _on_tut_select_button_pressed():
	_load_main_game("Tutorial (Go for a Perfect!)")

func _on_tim_select_button_pressed():
	_load_main_game("Ticking Village")
	
func _load_main_game(songName):
	$Conductor.stop()
	$SelectSFX.play()
	set_process_unhandled_input(false)
	var tween = self.create_tween()
	tween.tween_property($LevelEndFade, "color:a", 1, 1.57)
	ScoreSingleton.songName = songName

func _on_settings_button_pressed():
	$Control/SettingsButton.release_focus()
	$SettingsMenu.catchFocus()
	$SettingsMenu.visible = true
	
func changeVolume():
	$Conductor.volume_db = SettingsSingleton.songVolume
	
func returnFocus():
	$Control/SettingsButton.grab_focus()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_select_sfx_finished():
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")

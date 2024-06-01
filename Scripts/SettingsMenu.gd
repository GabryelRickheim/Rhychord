extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/SongVolumeContainer/SongVolumeHSlider.set_value_no_signal(
		db_to_linear(SettingsSingleton.songVolume))
	$VBoxContainer/HitsoundVolumeContainer/HitsoundVolumeHSlider.set_value_no_signal(
		db_to_linear(SettingsSingleton.hitSoundVolume))
	$VBoxContainer/SongSpeedContainer/SongSpeedHSlider.set_value_no_signal(SettingsSingleton.speedAdd)
	$VBoxContainer/FullscreenContainer/FullscreenCheckBox.set_pressed_no_signal(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	$VBoxContainer/VSyncContainer/VSyncCheckBox.set_pressed_no_signal(DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			self.visible = false
			get_parent().returnFocus()

func catchFocus():
	$VBoxContainer/SongVolumeContainer/SongVolumeHSlider.set_value_no_signal(
		db_to_linear(SettingsSingleton.songVolume))
	$VBoxContainer/HitsoundVolumeContainer/HitsoundVolumeHSlider.set_value_no_signal(
		db_to_linear(SettingsSingleton.hitSoundVolume))
	$VBoxContainer/SongSpeedContainer/SongSpeedHSlider.set_value_no_signal(SettingsSingleton.speedAdd)
	$VBoxContainer/FullscreenContainer/FullscreenCheckBox.set_pressed_no_signal(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)
	$VBoxContainer/VSyncContainer/VSyncCheckBox.set_pressed_no_signal(DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED)
	$VBoxContainer/Button.grab_focus()

func _on_fullscreen_check_box_toggled(toggled_on):
	if !toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_song_volume_h_slider_value_changed(value):
	SettingsSingleton.songVolume = linear_to_db(value)
	get_parent().changeVolume()

func _on_hitsound_volume_h_slider_value_changed(value):
	SettingsSingleton.hitSoundVolume = linear_to_db(value)
	$AudioStreamPlayer.volume_db = SettingsSingleton.hitSoundVolume
	_play_hitsound()

func _on_song_speed_h_slider_value_changed(value):
	SettingsSingleton.speedAdd = value

func _on_button_pressed():
	self.visible = false
	get_parent().returnFocus()

func _on_v_sync_check_box_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _play_hitsound():
	if $VBoxContainer/HitsoundVolumeContainer/Timer.is_stopped():
		$AudioStreamPlayer.play()
		$VBoxContainer/HitsoundVolumeContainer/Timer.start()

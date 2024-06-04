extends Control

# Script responsável por controlar o menu de configurações do jogo


# Função chamada quando o nó é criado. Inicializa os controles com os valores padrão
func _ready():
	set_process_unhandled_input(false)
	$VBoxContainer/SongVolumeContainer/SongVolumeHSlider.set_value_no_signal(
		db_to_linear(SettingsSingleton.songVolume)
	)
	(
		$VBoxContainer/HitsoundVolumeContainer/HitsoundVolumeHSlider
		. set_value_no_signal(db_to_linear(SettingsSingleton.hitSoundVolume))
	)
	$VBoxContainer/SongSpeedContainer/SongSpeedHSlider.set_value_no_signal(
		SettingsSingleton.speedAdd
	)
	$VBoxContainer/FullscreenContainer/FullscreenCheckBox.set_pressed_no_signal(
		DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	)
	$VBoxContainer/VSyncContainer/VSyncCheckBox.set_pressed_no_signal(
		DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Função chamada quando a tecla ESC é pressionada. Fecha o menu de configurações
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			_quit_menu()


# Função chamada quando o menu de configurações é fechado.
# Esconde o menu e retorna o foco para o nó pai
func _quit_menu():
	self.visible = false
	set_process_unhandled_input(false)
	get_parent().returnFocus()


# Função chamada quando o menu de configurações é aberto. Mostra o menu e captura o foco
# Define os valores dos controles de acordo com as configurações atuais
func catchFocus():
	set_process_unhandled_input(true)
	$VBoxContainer/SongVolumeContainer/SongVolumeHSlider.set_value_no_signal(
		db_to_linear(SettingsSingleton.songVolume)
	)
	(
		$VBoxContainer/HitsoundVolumeContainer/HitsoundVolumeHSlider
		. set_value_no_signal(db_to_linear(SettingsSingleton.hitSoundVolume))
	)
	$VBoxContainer/SongSpeedContainer/SongSpeedHSlider.set_value_no_signal(
		SettingsSingleton.speedAdd
	)
	$VBoxContainer/FullscreenContainer/FullscreenCheckBox.set_pressed_no_signal(
		DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	)
	$VBoxContainer/VSyncContainer/VSyncCheckBox.set_pressed_no_signal(
		DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED
	)
	$VBoxContainer/Button.grab_focus()


# Função chamada quando o controle de tela cheia é alterado.
# Altera o modo de tela de acordo com o controle
func _on_fullscreen_check_box_toggled(toggled_on):
	if !toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


# Função chamada quando o controle de volume da música é alterado.
# Altera o volume da música de acordo com o controle
func _on_song_volume_h_slider_value_changed(value):
	SettingsSingleton.songVolume = linear_to_db(value)
	get_parent().changeVolume()


# Função chamada quando o controle de volume do som de acerto é alterado.
# Altera o volume do som de acerto de acordo com o controle
func _on_hitsound_volume_h_slider_value_changed(value):
	SettingsSingleton.hitSoundVolume = linear_to_db(value)
	$AudioStreamPlayer.volume_db = SettingsSingleton.hitSoundVolume
	_play_hitsound()


# Função chamada quando o controle de velocidade adicional da música é alterado.
# Altera a velocidade adicional da música de acordo com o controle
func _on_song_speed_h_slider_value_changed(value):
	SettingsSingleton.speedAdd = value


# Função chamada quando o botão de fechar é pressionado.
# Fecha o menu de configurações
func _on_button_pressed():
	_quit_menu()


# Função chamada quando o controle de sincronização vertical é alterado.
# Altera o modo de sincronização vertical de acordo com o controle
func _on_v_sync_check_box_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


# Função chamada quando o controle de volume do som de acerto é alterado.
# Toca o som de acerto quando o controle é alterado para que o jogador possa ouvir o volume
func _play_hitsound():
	if $VBoxContainer/HitsoundVolumeContainer/Timer.is_stopped():
		$AudioStreamPlayer.play()
		$VBoxContainer/HitsoundVolumeContainer/Timer.start()

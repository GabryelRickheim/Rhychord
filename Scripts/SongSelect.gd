extends Node2D

# Script responsável pela tela de seleção de músicas


# Função chamada quando o nó é criado
# Realiza o fade in e toca a música de fundo
func _ready():
	$LevelEndFade.color.a = 1
	$Conductor.initialize("res://Sound/Lydia ~Menu~.ogg", 120, 0.5)
	$Conductor.play()
	var tween = self.create_tween()
	tween.tween_property($LevelEndFade, "color:a", 0, 0.35)
	$Control/VBoxContainer/TUTSelectButton.grab_focus()


func _process(_delta):
	pass


# Função chamada quando a música de fundo termina
# Reinicia a música
func _on_conductor_finished():
	$Conductor.reset()
	$Conductor.play()


# Funções chamadas quando os botões de seleção de música são pressionados
# Carregam a cena do jogo principal com a música selecionada
func _on_ssd_select_button_pressed():
	_load_main_game("Sound-Speed Dash")


func _on_dtmn_select_button_pressed():
	_load_main_game("Determination")


func _on_tut_select_button_pressed():
	_load_main_game("Tutorial (Go for a Perfect!)")


func _on_tim_select_button_pressed():
	_load_main_game("Ticking Village")


func _on_nvm_select_button_pressed():
	_load_main_game("Nevermind The Rain")


# Função chamada quando um botão de seleção de música é pressionado
# Carrega a cena do jogo principal com a música selecionada depois de um fade out
func _load_main_game(songName):
	$Conductor.stop()
	$SelectSFX.play()
	for node in $Control/VBoxContainer.get_children():
		if node is Button:
			node.disabled = true
	for node in $Control.get_children():
		if node is Button:
			node.disabled = true
	var tween = self.create_tween()
	tween.tween_property($LevelEndFade, "color:a", 1, 1.57)
	ScoreSingleton.songName = songName


# Função chamada quando o botão de configurações é pressionado
# Exibe o menu de configurações
func _on_settings_button_pressed():
	$Control/SettingsButton.release_focus()
	$SettingsMenu.catchFocus()
	$SettingsMenu.visible = true


# Função responsável por atualizar o volume da música
func changeVolume():
	$Conductor.volume_db = SettingsSingleton.songVolume
	$SelectSFX.volume_db = SettingsSingleton.songVolume


# Função chamada quando o botão de voltar do menu de configurações é pressionado
func returnFocus():
	$Control/SettingsButton.grab_focus()


# Função chamada quando o botão de sair é pressionado
# Fecha o jogo
func _on_quit_button_pressed():
	get_tree().quit()


# Função chamada quando termina o fade out
# Carrega a cena do jogo principal
func _on_select_sfx_finished():
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")

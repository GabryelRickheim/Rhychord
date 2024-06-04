extends Node

# Script responsável por controlar a tela de pause


func _ready():
	pass


func _process(_delta):
	pass


# Função responsável por criar atalhos para as funções da tela de pause
# Reinicia a fase ao pressionar a tecla R
# Fecha a tela de pause ao pressionar a tecla ESC
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_R:
			get_tree().paused = false
			get_tree().reload_current_scene()
		elif event.pressed and event.keycode == KEY_ESCAPE:
			self.visible = false
			get_tree().paused = false


# Função responsável por retomar a execução do jogo ao pressionar o botão de resume
func _on_resume_button_pressed():
	self.visible = false
	get_tree().paused = false


# Função responsável por reiniciar a fase ao pressionar o botão de reiniciar
func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


# Função responsável por fechar a tela de pause e voltar para a tela de seleção de músicas
# ao pressionar o botão de quit song
func _on_quit_song_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/SongSelect.tscn")

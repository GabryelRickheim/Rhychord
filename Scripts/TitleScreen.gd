extends Control

# Script responsável por controlar a tela de título do jogo


# Exibe a tela de título depois de um fade-in e inicia a música de fundo
func _ready():
	$LevelEndFade.color.a = 1
	$Conductor.initialize("res://Sound/Lydia ~Main Menu~.ogg", 120, 1)
	$Conductor.play()
	var tween = self.create_tween()
	tween.tween_property($LevelEndFade, "color:a", 0, 0.35)


# Reinicia a música de fundo quando ela termina
func _on_conductor_finished():
	$Conductor.reset()
	$Conductor.play()


# Inicia o jogo quando a tecla de espaço é pressionada
# e faz um fade-out da tela de título
# Fecha o jogo quando a tecla ESC é pressionada
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
		elif event.pressed and event.keycode == KEY_SPACE:
			$Conductor.stop()
			$TextureRect.on_game_start()
			$Label.on_game_start()
			$SelectSFX.play()
			set_process_unhandled_input(false)
			var tween = self.create_tween()
			tween.tween_property($LevelEndFade, "color:a", 1, 1.57)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Muda para a cena de seleção de músicas quando o fade-out termina
func _on_audio_stream_player_finished():
	get_tree().change_scene_to_file("res://Scenes/SongSelect.tscn")

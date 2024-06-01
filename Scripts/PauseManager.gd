extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_R:
			get_tree().paused = false
			get_tree().reload_current_scene()
		elif event.pressed and event.keycode == KEY_ESCAPE:
			self.visible = false
			get_tree().paused = false

func _on_resume_button_pressed():
	self.visible = false
	get_tree().paused = false


func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_song_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/SongSelect.tscn")

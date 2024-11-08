extends Button

var songName = ""

signal songFocused(songName)
signal songSelected(songName)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func initialize(songNameArg):
	self.songName = songNameArg
	if songNameArg.length() > 20:
		self.text = songNameArg.left(20) + "...  "
	else:
		self.text = songNameArg + "  "


func _on_focus_entered():
	emit_signal("songFocused", songName)


func _on_pressed():
	emit_signal("songSelected", songName)

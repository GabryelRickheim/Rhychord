extends Node

var songVolume = -6
var hitSoundVolume = -12
var speedAdd = 256

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func reset():
	songVolume = -6
	hitSoundVolume = -12
	speedAdd = 256

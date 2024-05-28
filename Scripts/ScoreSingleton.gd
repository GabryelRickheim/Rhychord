extends Node

var score = 0
var perfects = 0
var goods = 0
var earlys = 0
var lates = 0
var misses = 0
var percentage = 0
var rank = "F"
var songName = "Song Name"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func reset():
	score = 0
	perfects = 0
	goods = 0
	earlys = 0
	lates = 0
	misses = 0
	percentage = 0
	rank = "F"
	songName = "Song Name"

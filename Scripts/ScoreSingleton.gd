extends Node

var score = 99999
var perfects = 999
var goods = 999
var earlys = 999
var lates = 999
var misses = 0
var maxCombo = 999
var percentage = 100
var rank = "SS"
var songName = "Determination"
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
	songName = "Determination"

extends Node2D

var bpm = 360
var beatsPerBar = 4
var message = ""
var perfectTimingWindow = (60.0 / bpm) / 5
var goodTimingWindow = (60.0 / bpm) / 3

# Called when the node enters the scene tree for the first time.
func _ready():
	print(perfectTimingWindow)
	print(goodTimingWindow)
	print(60.0 / bpm)
	$Conductor.play_with_beat_offset(4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_Note_Pressed(note):
	print(note)
	message = "Time off: " + "%.010f" % ($Conductor.closest_beat()[1])
	if ($Conductor.closest_beat()[1] < perfectTimingWindow && $Conductor.closest_beat()[1] > 0 - perfectTimingWindow):
		$Label.set_text("Perfect!!! " + message)
	elif ($Conductor.closest_beat()[1] < goodTimingWindow && $Conductor.closest_beat()[1] > 0 - goodTimingWindow):
		$Label.set_text("Good! " + message)
	else:
		$Label.set_text("BAD! " + message)

func _on_Conductor_beat(beatPosition):
	print("Beat: ", beatPosition)
	$AudioStreamPlayer.play()

func _on_Conductor_bar(_barPosition):
	pass
	

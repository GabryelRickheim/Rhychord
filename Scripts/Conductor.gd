extends AudioStreamPlayer

var bpm = 0
var beatsPerBar = 0
var songPosition = 0
var songPositionInBeats = 0
var secPerBeat = 0
var lastReportedBeat = -1
var beatsBeforeStart = 0
var currentBar = 1
var closest = 0
var timeOffBeat = 0.0

signal beat(beatPosition)
signal bar(barPosition)

var song = preload("res://Sound/song.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.stream = song
	bpm = get_parent().bpm
	beatsPerBar = get_parent().beatsPerBar
	secPerBeat = get_parent().secsPerBeat
	songPosition = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.playing:
		songPosition = get_playback_position() + AudioServer.get_time_since_last_mix()
		songPosition -= AudioServer.get_output_latency()
		songPositionInBeats = int(floor(songPosition / secPerBeat)) + beatsBeforeStart
		_report_beat()

func _report_beat():
	if lastReportedBeat < songPositionInBeats:
		if currentBar > beatsPerBar:
			currentBar = 1
		emit_signal("beat", songPositionInBeats - (beatsBeforeStart - 1))
		emit_signal("bar", currentBar)
		lastReportedBeat = songPositionInBeats
		currentBar += 1
		
func play_with_beat_offset(num):
	beatsBeforeStart = num
	$StartTimer.wait_time = secPerBeat
	$StartTimer.start()

func _on_StartTimer_timeout():
	_report_beat()
	songPositionInBeats += 1
	if songPositionInBeats < beatsBeforeStart:
		$StartTimer.start()
	elif songPositionInBeats == beatsBeforeStart:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()


extends AnimatedSprite2D

var perfect = false
var good = false
var okay = false
var current_note = null

@export var input = ""

signal notePressed(input)

func _unhandled_input(event):
	if event.is_action("ui_" + input):
		if event.is_action_pressed("ui_" + input):
			emit_signal("notePressed", input)
			frame = 1
		elif event.is_action_released("ui_" + input):
			$Timer.start()

func _on_PushTimer_timeout():
	frame = 0

func _reset():
	current_note = null
	perfect = false
	good = false
	okay = false

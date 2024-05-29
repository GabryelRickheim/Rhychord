extends AnimatedSprite2D

var notes = []
var inputs = ["left", "up", "right", "down"]

@export var input = ""

signal notePressed(input)

func _unhandled_input(event):
	if event.is_action("ui_" + input):
		if event.is_action_pressed("ui_" + input):
			emit_signal("notePressed", input)
			frame = 1
			if !notes.is_empty():
				var note = notes[0]
				for n in notes:
					if n.index < note.index:
						note = n
				notes.erase(note)
				note.hit = true
				note.destroy()
		elif event.is_action_released("ui_" + input):
			frame = 0

func _reset():
	notes = []
	
func _on_area_2d_area_entered(area):
	if area.lane == inputs.find(input):
		notes.append(area)

func _on_area_2d_area_exited(area):
	if !area.hit and area.lane == inputs.find(input):
		notes.erase(area)
		area.destroy()

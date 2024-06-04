extends Area2D

var notes = []
var inputs = ["left", "up", "right", "down"]
var tween

@export var input = ""

signal notePressed(input)

func _unhandled_input(event):
	if event.is_action("ui_" + input):
		if event.is_action_pressed("ui_" + input):
			emit_signal("notePressed", input)
			$AnimatedSprite2D.frame = 1
			if !notes.is_empty():
				var note = notes[0]
				for n in notes:
					if n.index < note.index:
						note = n
				notes.erase(note)
				note.hit = true
				note.destroy()
				animate()
		elif event.is_action_released("ui_" + input):
			$AnimatedSprite2D.frame = 0

func animate():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "scale", Vector2(1.15, 1.15), 0.02)
	tween.tween_property($AnimatedSprite2D, "scale", Vector2(1, 1), 0.04)

func _reset():
	notes = []
	
func _on_area_2d_area_entered(area):
	if area.lane == inputs.find(input):
		notes.append(area)

func _on_area_2d_area_exited(area):
	if !area.hit and (area.lane == inputs.find(input)):
		notes.erase(area)
		area.destroy()

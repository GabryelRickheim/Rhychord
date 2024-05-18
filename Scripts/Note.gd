extends Area2D

var bpm = 0
var speed = 0
var hit = false
var lane = 0
var index = 0

signal destroyed(index, hit)

func _ready():
	pass
	
func _physics_process(delta):
	if !hit:
		position.y += speed * delta
	else:
		$Node2D.position.y -= speed * delta


func initialize(laneArg, bpmArg, indexArg):
	self.lane = laneArg
	self.bpm = bpmArg
	self.index = indexArg
	speed = (768 / (60.0 / bpmArg)) / 3
	position.y = -64
	if laneArg == 0:
		$AnimatedSprite2D.frame = 0
		position.x = 192
	elif laneArg == 1:
		$AnimatedSprite2D.frame = 1
		position.x = 320
	elif laneArg == 2:
		$AnimatedSprite2D.frame = 2
		position.x = 576
	elif laneArg == 3:
		$AnimatedSprite2D.frame = 3
		position.x = 448
	else:
		printerr("Invalid laneArg set for note: " + str(laneArg))
		return

func destroy():
	$AnimatedSprite2D.visible = false
	emit_signal("destroyed", index, hit)
	queue_free()

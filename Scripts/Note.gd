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


func initialize(lane, bpm, index):
	self.lane = lane
	self.bpm = bpm
	self.index = index
	speed = (768 / (60.0 / bpm)) / 3
	position.y = -64
	if lane == 0:
		$AnimatedSprite2D.frame = 0
		position.x = 192
	elif lane == 1:
		$AnimatedSprite2D.frame = 1
		position.x = 320
	elif lane == 2:
		$AnimatedSprite2D.frame = 2
		position.x = 576
	elif lane == 3:
		$AnimatedSprite2D.frame = 3
		position.x = 448
	else:
		printerr("Invalid lane set for note: " + str(lane))
		return

func destroy():
	$AnimatedSprite2D.visible = false
	emit_signal("destroyed", index, hit)
	queue_free()

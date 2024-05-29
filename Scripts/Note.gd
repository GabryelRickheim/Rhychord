extends Area2D

var bpm = 0
var speed = 0
var hit = false
var lane = 0
var index = 0
var speedAdd = 0

signal destroyed(index, hit)

func _ready():
	pass
	
func _physics_process(delta):
	if !hit:
		if lane == 0:
			position.x += speed * delta
		elif lane == 1:
			position.y += speed * delta
		elif lane == 2:
			position.x -= speed * delta
		elif lane == 3:
			position.y -= speed * delta
		else:
			$Node2D.position.y -= speed * delta


func initialize(laneArg, indexArg, startDelay, speedAddArg):
	self.lane = laneArg
	self.index = indexArg
	self.speedAdd = speedAddArg
	speed = ((384 + speedAdd) / startDelay)
	if laneArg == 0:
		$AnimatedSprite2D.frame = 0
		position.x = -36 - speedAdd
		position.y = 384
	elif laneArg == 1:
		$AnimatedSprite2D.frame = 1
		position.x = 384
		position.y = -36 - speedAdd
	elif laneArg == 2:
		$AnimatedSprite2D.frame = 2
		position.x = 768 + 36 + speedAdd
		position.y = 384
	elif laneArg == 3:
		$AnimatedSprite2D.frame = 3
		position.x = 384
		position.y = 768 + 36 + speedAdd
	else:
		printerr("Invalid laneArg set for note: " + str(laneArg))
		return

func destroy():
	$AnimatedSprite2D.visible = false
	emit_signal("destroyed", index, hit)
	if hit:
		$GPUParticles2D.emitting = true
		$Timer.start()
	else:
		queue_free()

func _on_timer_timeout():
	queue_free()

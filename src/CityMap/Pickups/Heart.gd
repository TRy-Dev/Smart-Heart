extends Pickup

export(float, 0.1, 60.0) var alive_time = 10.0

onready var death_timer = $DeathTimer
onready var anim_timer = $AnimateFrameTimer
onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer

const FRAME_COUNT = 6
var current_frame = 0
var frame_dir = 1
var start_frame = 0
var end_frame = 3

func _ready():
	anim_timer.start()
	death_timer.wait_time = alive_time
	death_timer.start()
	sprite.modulate = Color("#958b99")
	yield(get_tree().create_timer(0.5 * alive_time), "timeout")
	sprite.modulate = Color("#572a2a") 
	start_frame = 3
	end_frame = FRAME_COUNT - 1

func _on_area_entered(area):
	emit_signal("collected", self)
	_destroy()

func next_frame():
	current_frame += frame_dir
	sprite.frame = current_frame
	if current_frame <= start_frame and frame_dir == -1:
		current_frame = start_frame
		frame_dir = 1
	elif current_frame >= end_frame and frame_dir == 1:
		current_frame = end_frame
		frame_dir = -1

func _on_AnimateFrameTimer_timeout():
	next_frame()

func _on_DeathTimer_timeout():
	emit_signal("expired", self)
	_destroy()

func _destroy():
	queue_free()
	AnimationController.play(anim_player, "hide")

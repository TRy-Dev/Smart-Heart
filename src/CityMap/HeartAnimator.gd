extends Node2D

onready var timer = $Timer
# 
var anim_frames = 3
var anim_dir = 1
const DANGER_OFFSET = 3

var current_anim_frame = 0

var _hearts = []

func initialize(day_idx) -> void:
	_hearts = []
	current_anim_frame = 0
	anim_dir = 1
	timer.wait_time = 60.0 / (float(GlobalConstants.day_data(day_idx).bpm) * anim_frames)
	timer.start()

func stop():
	timer.stop()

func _on_Timer_timeout():
	_next_frame()

func _next_frame():
	for h in _hearts:
		if not h:
			return
		if h.in_danger:
			h.set_current_frame(DANGER_OFFSET + current_anim_frame)
		else:
			h.set_current_frame(current_anim_frame)
	current_anim_frame += anim_dir
	if current_anim_frame <= 0 and anim_dir == -1:
		current_anim_frame = 0
		anim_dir = 1
	elif current_anim_frame >= anim_frames - 1 and anim_dir == 1:
		current_anim_frame = anim_frames - 1
		anim_dir = -1

func _on_heart_created(h):
	_hearts.append(h)

func _on_heart_collected(h):
	_hearts.erase(h)

func _on_heart_expired(h):
	_hearts.erase(h)


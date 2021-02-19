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
		AudioController.sfx.play("heart1", _get_heartbeat_volume_db())
	elif current_anim_frame >= anim_frames - 1 and anim_dir == 1:
		current_anim_frame = anim_frames - 1
		anim_dir = -1
		AudioController.sfx.play("heart2", _get_heartbeat_volume_db())

func _on_heart_created(h):
	_hearts.append(h)

func _on_heart_collected(h):
	_hearts.erase(h)

func _on_heart_expired(h):
	_hearts.erase(h)

func _get_heartbeat_volume_db() -> int:
	var score := 0
	for h in _hearts:
		if h.in_danger:
			score += 2
		else:
			score += 1
	if score == 0:
		return -80
	score *= score
	var volume_db = Math.map(score, 1, 30, -20, -8)
	volume_db = clamp(volume_db, -80, -8)
	return volume_db

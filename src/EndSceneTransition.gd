extends Node2D

onready var heartbeat_audio = $HeartBeat
onready var body_fall = $BodyFall
onready var my_courtain = $Courtain

const PITCH_FROM = 1.0
const PITCH_TO = 1.4
const PITCH_STEP = 0.03
const START_VOLUME_DB = -4
const END_VOLUME_DB = -14
const END_BEAT_COUNT = 10

var beat_count = 0

var end_scene = preload("res://src/EndScene.tscn")

func start():
	my_courtain.play("fade_in")
	Courtain.play("flash")
	heartbeat_audio.pitch_scale = PITCH_FROM
	heartbeat_audio.volume_db = START_VOLUME_DB
	heartbeat_audio.play()

func _on_AudioStreamPlayer_finished():
	if heartbeat_audio.pitch_scale < PITCH_TO - PITCH_STEP or beat_count < END_BEAT_COUNT:
		heartbeat_audio.pitch_scale += PITCH_STEP
		heartbeat_audio.pitch_scale = clamp(heartbeat_audio.pitch_scale, PITCH_FROM, PITCH_TO)
		heartbeat_audio.volume_db = Math.map(heartbeat_audio.pitch_scale, 
				PITCH_FROM, PITCH_TO, START_VOLUME_DB, END_VOLUME_DB)
		heartbeat_audio.play()
		Courtain.play("flash")
		if heartbeat_audio.pitch_scale >= PITCH_TO - PITCH_STEP:
			beat_count += 1
	else:
		Courtain.play("flash")
		yield(get_tree().create_timer(1.5), "timeout")
		Courtain.play("flash")
		body_fall.play()
		yield(body_fall, "finished")
		SceneController.load_scene(end_scene)

extends Pickup

onready var anim_player = $AnimationPlayer
onready var light_anim = $LightAnimation
onready var cooldown_timer = $CooldownTimer

var ambulances = []

const STOP_PROBABILITY = 0.15
const COOLDOWN_MIN_TIME = 9.0
const COOLDOWN_MAX_TIME = 12.0

var is_stopping = false

func _ready():
	cooldown_timer.wait_time = Rng.randf(COOLDOWN_MIN_TIME, COOLDOWN_MAX_TIME)
	cooldown_timer.start()

func _on_area_entered(area):
	ambulances.append(area.owner)
	if is_stopping:
		area.owner.is_stopped = true

func _on_Area2D_area_exited(area):
	ambulances.erase(area.owner)

func _on_CooldownTimer_timeout():
	if Rng.randf() < STOP_PROBABILITY:
		_start_stop()

func _start_stop():
	is_stopping = true
	for a in ambulances:
		a.is_stopped = true
	$StopTimer.start()
	AnimationController.play(anim_player, "show")
	AnimationController.play(light_anim, "flicker")

func _on_StopTimer_timeout():
	is_stopping = false
	for a in ambulances:
		a.is_stopped = false
	AnimationController.play(anim_player, "show", false, true)
	AnimationController.reset(light_anim)

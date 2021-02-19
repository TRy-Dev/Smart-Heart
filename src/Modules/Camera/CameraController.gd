extends Camera2D

onready var tween_zoom = $ZoomTween
onready var tween_rotate = $RotateTween

const TRANS_TYPE = Tween.TRANS_SINE
const EASE_TYPE = Tween.EASE_IN_OUT

#const ZOOM_MIN = 0.25
#const ZOOM_MAX = 2.0
const ZOOM_DURATION = 1.0

const ROT_MIN = -180
const ROT_MAX = 180
const ROT_DURATION = 2.0

const SHAKE_DECAY = 0.8
const SHAKE_MAX_OFFSET = Vector2(100, 75)
const SHAKE_MAX_ROLL = 0.1
const SHAKE_TRAUMA_POWER = 3
var shake_trauma = 0.0

var noise_y = 0
var noise_seed = 0

var _target = null

var _zoom_levels = {
	"close": 0.35,
	"far": 0.5,
}

func _ready():
	randomize()
	noise_seed = Rng.noise_seed()

func _process(delta: float) -> void:
	if _target:
		global_position = _target.global_position
	if shake_trauma:
		shake_trauma = max(shake_trauma - SHAKE_DECAY * delta, 0)
		shake()

func set_target(target):
	_target = target

func set_target_instant(target):
	set_target(target)
	if _target:
		global_position = _target.global_position
	reset_smoothing()

func set_zoom_level(name, smoothed := true):
	if not _zoom_levels.get(name):
		print("HEY! Zoom level not found: %s" %name)
		return
	_set_zoom(_zoom_levels[name], smoothed)

func _set_zoom(val, smoothed := true):
#	val = clamp(val, ZOOM_MIN, ZOOM_MAX)
	tween_zoom.stop_all()
	if smoothed:
		tween_zoom.interpolate_property(self, "zoom", zoom, Vector2.ONE * val, ZOOM_DURATION, TRANS_TYPE, EASE_TYPE)
		tween_zoom.start()
	else:
		zoom = Vector2.ONE * val

func set_rotation(val, smoothed := true):
	val = clamp(val, ROT_MIN, ROT_MAX)
	val = deg2rad(val)
	tween_rotate.stop_all()
	if smoothed:
		tween_rotate.interpolate_property(self, "rotation", rotation, val, ROT_DURATION, TRANS_TYPE, EASE_TYPE)
		tween_rotate.start()
	else:
		rotation = val

func add_trauma(amount):
	shake_trauma = clamp(shake_trauma + amount, 0.0, 1.0)

func shake():
	var amount = pow(shake_trauma, SHAKE_TRAUMA_POWER)
	noise_y += 1
	rotation = SHAKE_MAX_ROLL * amount * Rng.noise(noise_seed, noise_y)
	offset.x = SHAKE_MAX_OFFSET.x * amount * Rng.noise(noise_seed + 10, noise_y)
	offset.y = SHAKE_MAX_OFFSET.y * amount * Rng.noise(noise_seed + 100, noise_y)

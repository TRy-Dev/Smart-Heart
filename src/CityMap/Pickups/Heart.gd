extends Pickup

#export(float, 0.1, 60.0) var alive_time = 10.0

onready var death_timer = $DeathTimer
onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer

var in_danger = false
var collected = false

func initialize(pos: Vector2, day_idx: int) -> void:
	var alive_time = GlobalConstants.day_data(day_idx).heart_alive_time
	.initialize(pos, day_idx)
	AnimationController.play(anim_player, "show", false)
	death_timer.wait_time = alive_time
	death_timer.start()
	sprite.modulate = Color("#8f0e0e")
	yield(get_tree().create_timer(0.5 * alive_time), "timeout")
	in_danger = true
	sprite.modulate = Color("#de1616")

func _on_area_entered(area):
	if not collected:
		emit_signal("collected", self)
		collected = true
		_destroy()

func set_current_frame(idx: int) -> void:
	sprite.frame = idx

func _on_DeathTimer_timeout():
	if not collected:
		yield(_destroy(), "completed")
	if not collected:
		emit_signal("expired", self)

func _destroy():
	AnimationController.play(anim_player, "hide")
	yield(anim_player, "animation_finished")
	queue_free()

extends PlatformerState

func update(input: Dictionary) -> void:
	if input["grounded"]:
		emit_signal("finished", "pop")
	set_velocity(Vector2(input["move"] * walk_speed, vel_gravity), true, false)
	if input["stop-jump"]:
		stop_jump()

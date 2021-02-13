extends PlatformerState

class_name OnGround

func update(input: Dictionary) -> void:
	if not input["grounded"]:
		emit_signal("finished", "InAir")
	if input["jump"] and input["grounded"]:
		set_velocity(Vector2(input["move"] * walk_speed, max_jump_speed), true, true)
	else:
		set_velocity(Vector2(input["move"] * walk_speed, vel_gravity), true, false)

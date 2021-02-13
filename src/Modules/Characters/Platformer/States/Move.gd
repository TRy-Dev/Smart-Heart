extends OnGround

func update(input: Dictionary) -> void:
	if not input["move"] or abs(get_velocity().x) < Math.EPSILON:
		emit_signal("finished", "Idle")
	.update(input)

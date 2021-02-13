extends OnGround

func update(input: Dictionary) -> void:
	if input["move"] and abs(get_velocity().x) > Math.EPSILON:
		emit_signal("finished", "Move")
	.update(input)

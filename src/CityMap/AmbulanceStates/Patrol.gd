extends State

func enter(previous: State) -> void:
	owner.play_anim("signals_on")

func exit(next: State) -> void:
	owner.play_anim("_reset")

func update(input: Dictionary) -> void:
	var dir = owner.get_current_move_direction()
	if dir == Vector2.ZERO or owner.get_fuel() <= 0.0:
		emit_signal("finished", "BackToGarage")
		return
	if owner.is_selected and Input.is_action_just_pressed("rmb"):
		owner.submit_path_to_mouse()
	var delta_pos_mag = input["delta"] * owner.SPEED
	var dist = owner.distance_to_next_point()
	delta_pos_mag = min(delta_pos_mag, dist)
	owner.update_global_position(dir * delta_pos_mag)
	owner.update_fuel_delta(-delta_pos_mag)
	owner.update_path_line()

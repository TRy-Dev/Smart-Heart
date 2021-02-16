extends State

func enter(previous: State) -> void:
	owner.force_refuel_path()
	owner.unselect()

func update(input: Dictionary) -> void:
	if owner.is_on_home_position():
		emit_signal("finished", "InGarage")
		return
	var delta_pos_mag = input["delta"] * owner.SPEED
	var dir = owner.get_current_move_direction()
	var dist = owner.distance_to_next_point()
	delta_pos_mag = min(delta_pos_mag, dist)
	owner.update_global_position(dir * delta_pos_mag)
	owner.update_path_line()

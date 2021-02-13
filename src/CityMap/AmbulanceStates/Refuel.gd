extends State

const MIN_DIST_TO_NEXT_POINT = 0.1


func enter(previous: State) -> void:
	owner.force_refuel_path()

# Called by parent StateMachine.
func update(input: Dictionary) -> void:
	var dir = owner.get_current_move_direction()
	if owner.is_on_home_position(): #dir == Vector2.ZERO:
		emit_signal("finished", "InGarage")
		return
	if owner.is_selected and Input.is_action_just_pressed("rmb"):
		if owner.get_fuel() > 0.0:
			owner.force_path_to_mouse()
			emit_signal("finished", "Patrol")
			return
		else:
			owner.submit_path_to_mouse()
	var delta_pos_mag = input["delta"] * owner.SPEED
	var dist = owner.distance_to_next_point()
	delta_pos_mag = min(delta_pos_mag, dist)
	owner.update_global_position(dir * delta_pos_mag)
	owner.update_fuel_delta(-delta_pos_mag)
#	if dist <= MIN_DIST_TO_NEXT_POINT:
#		owner.pop_closest_point()
	owner.update_path_line()

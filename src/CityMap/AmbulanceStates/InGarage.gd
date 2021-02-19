extends State

const FUEL_REGEN_SPEED = 90.0

func enter(previous: State) -> void:
	owner.force_remove_path()

func update(input: Dictionary) -> void:
	owner.update_fuel_delta(input["delta"] * FUEL_REGEN_SPEED)
	if owner.is_selected and Input.is_action_just_pressed("rmb"):
		owner.submit_path_to_mouse()
	if owner.has_current_path():
		emit_signal("finished", "Patrol")
		return

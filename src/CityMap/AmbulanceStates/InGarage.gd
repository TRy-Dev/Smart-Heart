extends State

func enter(previous: State) -> void:
	owner.refuel()

func update(input: Dictionary) -> void:
	if owner.is_selected and Input.is_action_just_pressed("rmb"):
		owner.submit_path_to_mouse()
	if owner.has_current_path():
		emit_signal("finished", "Patrol")
		return

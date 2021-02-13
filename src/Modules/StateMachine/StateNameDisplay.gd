extends Label

func _on_state_changed(previous_state, current_state):
	text = current_state.name

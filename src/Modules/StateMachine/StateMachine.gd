extends Node

# https://github.com/GDQuest/godot-demos/tree/master/2018/04-24-finite-state-machine

class_name StateMachine

signal state_changed(previous, current)

# Public, as sometimes other FSM might need to check current state
var current_state = null

var _states_map = {}
var _states_stack = []

# Min 2 for pushdown automata ('pop'ing) to work. Set higher if longer history needed.
const MAX_STACK_SIZE = 2

func initialize() -> void:
	_states_map = {}
	if not get_child_count():
		push_error("HEY! FSM %s of %s has 0 states." % [name, owner.name])
		return
	for c in get_children():
		_states_map[c.name] = c
		if not c.get_signal_connection_list("finished"):
			c.connect("finished", self, "_change_state")
		c.initialize()
	_change_state(get_child(0).name)

func update(input) -> void:
	current_state.update(input)

func _on_animation_finished(anim_name) -> void:
	current_state.animation_finished(anim_name)

func _change_state(new_state_name) -> void:
	if current_state and current_state.name == new_state_name:
		return
	var previous_state = current_state
	if new_state_name == "pop":
		_states_stack.pop_front()
	else:
		if not new_state_name in _states_map:
			print("HEY! No such FSM state: %s" % new_state_name)
			return
		_states_stack.push_front(_states_map[new_state_name])
		if len(_states_stack) > MAX_STACK_SIZE:
			_states_stack = _states_stack.slice(0, MAX_STACK_SIZE)
	current_state = _states_stack[0]
	if previous_state:
		previous_state.exit(current_state)
	current_state.enter(previous_state)
	emit_signal("state_changed", previous_state, current_state)

extends Node

# https://github.com/GDQuest/godot-demos/tree/master/2018/04-24-finite-state-machine

class_name State

# warning-ignore:unused_signal
signal finished(next_state_name)

# Called once during FSM initialization.
func initialize() -> void:
#	print("Initializing state %s" % name)
	pass

# Reset the state. E.g. change the animation.
func enter(previous: State) -> void:
#	print("From %s entered %s" % [previous.name if previous else "NULL", name])
	pass

# Clean up the state. Reinitialize values like a timer.
func exit(next: State) -> void:
#	print("Exiting from state %s to %s" % [name, next.name])
	pass

# Called by parent StateMachine.
func update(input: Dictionary) -> void:
#	print("Updating state %s with input: %s" % [name, input])
	pass

func animation_finished(anim_name: String) -> void:
#	print("Animation %s finished. State: %s" % [anim_name, name])
	pass

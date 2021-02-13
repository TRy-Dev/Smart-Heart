extends KinematicBody2D

onready var movement_fsm = $MovementStateMachine

var velocity := Vector2()

func _ready() -> void:
	init_state_machines()

func init_state_machines():
	movement_fsm.connect("state_changed", $StateNameDisplay, "_on_state_changed")
	movement_fsm.initialize()

func update() -> void:
	movement_fsm.update(_get_player_input())
	velocity = move_and_slide(velocity, Vector2.UP)

func _get_player_input() -> Dictionary:
	return {
		"move": Input.get_action_strength("right") - Input.get_action_strength("left"),
		"jump": Input.is_action_just_pressed("space"),
		"stop-jump": Input.is_action_just_released("space"),
		"grounded": is_on_floor()
	}

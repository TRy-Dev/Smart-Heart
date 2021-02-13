extends Node2D

class_name Tile

signal tile_destroyed(tile)

onready var sprite :Sprite = $Sprite
onready var fsm :StateMachine = $StateMachine
onready var anim_player :AnimationPlayer = $AnimationPlayer
onready var collider = $DynamicCollider

export (int, 0, 4) var speed := 0

var grid_position: Vector2
var tile_index: int

var destroyed = false

func initialize(grid_pos: Vector2, idx: int) -> void:
	grid_position = grid_pos
	tile_index = idx
	global_position = GlobalConstants.grid_to_world(grid_pos)
	AnimationController.play(anim_player, "show", false)
	fsm.connect("state_changed", $StateNameDisplay, "_on_state_changed")
	fsm.initialize()

func destroy() -> void:
	if destroyed:
		return
	AnimationController.play(anim_player, "hide")
	destroyed = true
	yield(anim_player, "animation_finished")
	emit_signal("tile_destroyed", self)
	queue_free()

func update_state_machine(input: Dictionary) -> void:
	fsm.update(input)

## GOLF

func on_player_entered(player: Player) -> void:
#	print("Player entered %s" %name)
	pass

func on_player_exited(player: Player) -> void:
#	print("Player exited %s" %name)
	pass

extends Node2D

class_name GridWorld

onready var _environment = $Environment
onready var _pawn_controller = $PawnController
onready var _tile_controller :TileController = $TileController
onready var _navigation :GridNavigation = $GridNavigation

var player_last_grid_pos = null

var is_updating_tiles = false

func initialize():
	var walkable_tilemap = _environment.get_walkable_tilemap()
	_navigation.initialize(walkable_tilemap)
	_pawn_controller.connect("tile_created", _navigation, "_on_pawn_created")
	_pawn_controller.connect("tile_destroyed", _navigation, "_on_pawn_destroyed")
	_pawn_controller.connect("pawn_moved", _navigation, "_on_pawn_moved")
	_pawn_controller.set_debug_mode(false)
	_tile_controller.set_debug_mode(false)
	_pawn_controller.initialize(walkable_tilemap)
	_tile_controller.initialize(walkable_tilemap)

func get_nav_path(pos_from: Vector2, pos_to: Vector2) -> Array:
	_navigation.set_node_at_disabled(pos_from, false)
	var grid_points = _navigation.get_nav_path(pos_from, pos_to)
	_navigation.set_node_at_disabled(pos_from, true)
	return grid_points

func update_tiles() -> void:
	is_updating_tiles = true
	var input = {
		"world": self,
		"tile_controller": _tile_controller,
		"pawn_controller": _pawn_controller,
	}
	_pawn_controller.update_all(input)
	_tile_controller.update_all(input)
	yield(get_tree().create_timer(GlobalConstants.MOVE_TIME), "timeout")
	is_updating_tiles = false

func is_position_unoccupied(pos: Vector2) -> bool:
	if not _environment.is_position_walkable(pos):
		return false
	if player_last_grid_pos == pos:
		return false
	if _pawn_controller.get_tile_at(pos):
		return false
	if _tile_controller.get_tile_at(pos):
		return false
	return true

# GOLF

func update_player_position(pos: Vector2) -> void:
	var grid_pos = _pawn_controller.world_to_map(pos)
	if grid_pos != player_last_grid_pos:
		if player_last_grid_pos != null:
			_navigation.set_node_at_disabled(player_last_grid_pos, false)
		_navigation.set_node_at_disabled(grid_pos, true)
		player_last_grid_pos = grid_pos

func save_state(save: Resource):
	_pawn_controller.save_state(save)
	_tile_controller.save_state(save)
#	_env.save_state(save_game)
#	save_game.data["pawns"] = {}
#	var pawns_grid_positions = _pawns_tilemap.get_used_cells()
#	for pos in pawns_grid_positions:
#		save_game.data["pawns"][pos] = _pawns_tilemap.get_cellv(pos)

func load_state(save: Resource):
	_pawn_controller.load_state(save)
	_tile_controller.load_state(save)
#	_env.load_state(save_game)
#	_pawns_tilemap.clear()
#	_pawns = {}
#	for c in _pawn_container.get_children():
#		c.queue_free()
#	for key in save_game.data["pawns"]:
#		var idx = save_game.data["pawns"][key]
#		create_pawn(idx, key)
#	validate_tilemap_and_pawns_equal()

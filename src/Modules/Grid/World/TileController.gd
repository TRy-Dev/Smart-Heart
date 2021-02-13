extends TileMap

class_name TileController

signal tile_created(idx, pos)
signal tile_destroyed(idx, pos)

## Dict Vector2 -> Pawn
var _tiles := {}

var save_key = ""

func _init():
	save_key = "tiles"

func initialize(walkable: TileMap) -> void:
	for tile in _tiles.values():
		tile.free()
	_tiles = {}
	var outside_walkable_count = 0
	for pos in get_used_cells():
		var idx = get_tile_id_at(pos)
		if walkable and walkable.get_cellv(pos) == -1:
			set_cellv(pos, -1)
			outside_walkable_count += 1
		else:
			create_tile(idx, pos)
	print("%s generated %s tiles" %[name, _tiles.size()])
	if outside_walkable_count:
		print("Removed %s tiles outside of walkable tilemap" % outside_walkable_count)
	_validate_tilemap_and_tiles_equal()

func create_tile(idx: int, pos: Vector2) -> Tile:
	var new_tile = _get_new_tile(idx, pos)
	new_tile.connect("tile_destroyed", self, "_on_tile_destroyed")
	_tiles[pos] = new_tile
	set_cellv(pos, idx)
	emit_signal("tile_created", idx, pos)
	return new_tile

func get_tile_id_at(pos) -> int:
	return get_cellv(pos)

func get_tile_at(pos) -> Tile:
	return _tiles.get(pos)

func destroy_tile(pos: Vector2) -> void:
	var idx = get_tile_id_at(pos)
	if idx == -1:
#		print("HEY! Trying to destoy non existent tile on position %s" %pos)
		return
	set_cellv(pos, -1)
	if not _tiles[pos].destroyed:
		_tiles[pos].destroy()
	_tiles.erase(pos)
	emit_signal("tile_destroyed", idx, pos)

func replace_tile(idx: int, pos: Vector2) -> void:
	destroy_tile(pos)
	create_tile(idx, pos)

func update_all(input: Dictionary) -> void:
#	input["pawn_controller"] = self
	for tile in _tiles.values():
		tile.update_state_machine(input)

func set_debug_mode(value) -> void:
	self_modulate.a = 1.0 if value else 0.0
	var tile_modulate = 0.0 if value else 1.0
	for c in get_children():
		c.modulate.a = tile_modulate
	__tilemap_self_modulate_bug_dirty_fix()
	print("Debug mode %s" % value)

func _get_new_tile(idx: int, pos: Vector2) -> Tile:
	return DataLoader.create_tile(idx, pos, self)

func _on_tile_destroyed(pawn) -> void:
	destroy_tile(pawn.grid_position)

func _validate_tilemap_and_tiles_equal():
	var grid_positions = get_used_cells()
	if not len(grid_positions) == get_child_count():
		# Check for duplicate Pawn positions
		var pawn_positions = []
		for pawn in get_children():
			if pawn.grid_position in pawn_positions:
				print("Duplicate position! %s" %pawn.grid_position)
				pawn.modulate = Rng.rand_rgb()
			else:
				pawn_positions.append(pawn.grid_position)
		if get_child_count() > len(grid_positions):
			for c in get_children():
				if not c.grid_position in grid_positions:
					print("Pawn %s is not on tilemap!" %c.name)
		else:
			pawn_positions = []
			for c in get_children():
				pawn_positions.append(c.grid_position)
			for pos in grid_positions:
				if not pos in pawn_positions:
					print("Pawn does not exist on position %s" %pos)
	var child_count = get_child_count()
	# BELOW SHOULD ALWAYS BE TRUE!
	assert(len(grid_positions) == len(_tiles.keys())
			and len(grid_positions) == get_child_count())
	for pos in grid_positions:
		var pawn = _tiles[pos]
		assert(_tiles.has(pos))
		assert(pawn.grid_position == pos)

func __tilemap_self_modulate_bug_dirty_fix():
	# https://github.com/godotengine/godot/issues/31413
	var _temp_tiles = {}
	for pos in get_used_cells():
		_temp_tiles[pos] = get_cellv(pos)
	clear()
	for pos in _temp_tiles.keys():
		set_cellv(pos, _temp_tiles[pos])

func save_state(save: Resource) -> void:
	save.data[save_key] = {}
	for pos in get_used_cells():
		var idx = get_cellv(pos)
		save.data[save_key][pos] = idx

func load_state(save: Resource) -> void:
	clear()
	for pos in save.data[save_key].keys():
		var idx = save.data[save_key][pos]
		set_cellv(pos, idx)
	# We assume we have not saved pawns on illegal positions, so walkable tilemap is not needed
	initialize(null)

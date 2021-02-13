extends TileController

signal pawn_moved(index, pos_from, pos_to)

func _init():
	save_key = "pawns"

func move_pawn(pos_from :Vector2, pos_to :Vector2) -> void:
	var dir := pos_to - pos_from
	if dir == Vector2.ZERO:
		return
	var pawn :Pawn = _tiles[pos_from]
	var index = pawn.tile_index
	if get_tile_id_at(pos_to) > -1:
		print("HEY! Pawn trying to move to occupied position %s" %pos_to)
		return
	# Validate tilemap
	assert(get_tile_id_at(pos_from) == pawn.tile_index, 
			"Could not find tile %s at position %s" % [index, pos_from]
	)
	# Validate dict
	assert(_tiles.has(pos_from),
			"Could not find pawn %s at position %s" % [index, pos_from]
	)
	# Move in tilemap
	set_cellv(pos_from, -1)
	set_cellv(pos_to, pawn.tile_index)
	# Move in dict
	_tiles.erase(pos_from)
	_tiles[pos_to] = pawn
	pawn.move_to(pos_to)
	emit_signal("pawn_moved", index, pos_from, pos_to)
	_validate_tilemap_and_tiles_equal()

func _get_new_tile(idx: int, pos: Vector2) -> Tile:
	return DataLoader.create_pawn(idx, pos, self)

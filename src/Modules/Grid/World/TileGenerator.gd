extends TileMap

func generate(positions: Array) -> void:
	for pos in positions:
		set_cellv(pos, 0)
		update_bitmask_area(pos)

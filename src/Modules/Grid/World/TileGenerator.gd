extends TileMap

export(float, 0.0, 1.0) var probability := 0.5
export(float, 0.1, 100000.0) var noise_scale := 3000.0
export(float, -1000000.0, 1000000.0) var z_offset := 0.0
export(float, -1000000.0, 1000000.0) var w_offset := 0.0

func generate(positions: Array) -> void:
	var tile_count = len(tile_set.get_tiles_ids())
	for pos in positions:
		var noise_pos = pos * noise_scale
		var noise = Rng.noise(noise_pos.x, noise_pos.y, z_offset, 0.0)
		if noise < probability:
			noise = Rng.noise(noise_pos.x, noise_pos.y, 0.0, w_offset)
			var tile_id = int(noise * tile_count)
			set_cellv(pos, tile_id)

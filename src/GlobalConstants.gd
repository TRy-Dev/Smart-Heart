extends Node

var TILE_SIZE := 16

func grid_to_world(grid_pos) -> Vector2:
	return (grid_pos + 0.5 * Vector2.ONE) * TILE_SIZE

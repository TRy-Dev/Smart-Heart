extends Node

var TILE_SIZE := 16

var _amb_names = [
	"Alpha",
	"Bravo",
	"Omega",
	"Alpha Bravo",
]

var bpm = 80

func get_amb_name_by_index(idx):
	if idx < 0:
		idx = 0
	idx = idx % len(_amb_names)
	return _amb_names[idx]

extends Node

var TILE_SIZE := 16

# https://www.nobelprize.org/prizes/lists/all-nobel-laureates-in-physiology-or-medicine/
var _amb_names = [
	["Alter", "Allison", "Axel", "Arber", "Axelrod", "Adrian"],
	["Beutler", "Blackburn", "Barré-Sinoussi", "Buck", "Brenner", 
		"Blobel", "Bishop", "Black", "Brown", "Bergström", "Benacerraf", 
		"Blumberg", "Baltimore", "Bloch", "Békésy", "Burnet", "Beadle", 
		"Bovet", "Banting", "Bordet", "Bárány", "Behring"],
	["Ochoa", "Ohsumi"],
	["Karl Landsteiner"],
]

var _DAY_DATA = {
	0: {
		"bpm": 80,
		"heart_alive_time": 12.0,
		"heart_spawn_rate": 2.5,
	},
	1: {
		"bpm": 240,
		"heart_alive_time": 5.0,
		"heart_spawn_rate": 1.0,
	}
}

func get_amb_name_by_index(idx):
	if idx < 0:
		idx = 0
	idx = idx % len(_amb_names)
	var amb_name = Rng.rand_array_element(_amb_names[idx])
	return amb_name

const DEFAULT_DAY = 0
func day_data(day_idx):
	if not _DAY_DATA.has(day_idx):
		print("Could not find data for day_idx %s. Returning default day_idx %s" %[day_idx, DEFAULT_DAY])
		return _DAY_DATA[DEFAULT_DAY]
	return _DAY_DATA[day_idx]




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
	0: { # Demo
		"bpm": 60,
		"heart_alive_time": 16.0,
		"heart_spawn_rate": 3.5,
		"extra_amb": false,
		"start_delay": 5.0,
		"traffic": false,
	},
	1: { # Real
		"bpm": 80,
		"heart_alive_time": 12.0,
		"heart_spawn_rate": 3.0,
		"extra_amb": false,
		"start_delay": 2.0,
		"traffic": false,
	},
	2: { # More customers
		"bpm": 80,
		"heart_alive_time": 12.0,
		"heart_spawn_rate": 2.5,
		"extra_amb": false,
		"start_delay": 2.0,
		"traffic": false,
	},
	3: { # Elderly
		"bpm": 100,
		"heart_alive_time": 10.0,
		"heart_spawn_rate": 2.5,
		"extra_amb": true,
		"start_delay": 2.0,
		"traffic": false,
	},
	4: { # Game Day
		"bpm": 120,
		"heart_alive_time": 10.0,
		"heart_spawn_rate": 2.0,
		"extra_amb": true,
		"start_delay": 2.0,
		"traffic": true,
	}
}

var _amb_names_this_session = []

var total_hearts_collected = 0
var total_hearts_expired = 0

func _ready():
	# Generate amb names
	for i in range(len(_amb_names)):
		_amb_names_this_session.append(Rng.rand_array_element(_amb_names[i]))

func get_amb_name_by_index(idx):
	if idx < 0:
		idx = 0
	idx = idx % len(_amb_names)
	var amb_name = _amb_names_this_session[idx] #Rng.rand_array_element(_amb_names[idx])
	return amb_name

const DEFAULT_DAY = 0
func day_data(day_idx):
	if not _DAY_DATA.has(day_idx):
		print("Could not find data for day_idx %s. Returning default day_idx %s" %[day_idx, DEFAULT_DAY])
		return _DAY_DATA[DEFAULT_DAY]
	return _DAY_DATA[day_idx]

func has_next_day(current_day):
	return _DAY_DATA.has(current_day + 1)

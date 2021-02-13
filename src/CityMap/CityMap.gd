extends Node2D

onready var buildings = $Buildings
onready var roads = $Roads
onready var grid_navigation = $GridNavigation
onready var ambulance_slots = $AmbulanceSlots

onready var path = $Path

var ambulance_prefab = preload("res://src/CityMap/Ambulance.tscn")
var heart_prefab = preload("res://src/CityMap/Heart.tscn")

var selected_ambulance = null

var _ambulances = []

# world_pos -> heart
var _hearts = {}

var road_world_positions = []

func initialize() -> void:
	_init_city()
	_init_ambulances()

func _init_city() -> void:
	var building_cells = buildings.get_used_cells()
	var roads_dict = {}
	for cell_pos in building_cells:
		for dir in Math.CARDINAL_DIRECTIONS + Math.CROSS_DIRECTIONS:
			var pos = cell_pos + dir
			if buildings.get_cellv(pos) == -1:
				roads_dict[pos] = null
	for pos in ambulance_slots.get_used_cells():
		roads_dict[pos] = null
	var road_cells = roads_dict.keys()
	roads.generate(road_cells)
	grid_navigation.initialize(roads)
	for pos in roads.get_used_cells():
		road_world_positions.append(GlobalConstants.grid_to_world(pos))
#		_spawn_heart(GlobalConstants.grid_to_world(pos))

func _init_ambulances() -> void:
	for pos in ambulance_slots.get_used_cells():
		var amb = ambulance_prefab.instance()
		add_child(amb)
		_ambulances.append(amb)
		amb.connect("clicked", self, "_on_ambulance_selected")
		amb.initialize(GlobalConstants.grid_to_world(pos), self)

func update_current_path():
	var points = PoolVector2Array()
	if not selected_ambulance:
		path.points = points
		return
	points = get_nav_path(selected_ambulance.get_last_nav_position(), get_global_mouse_position())
	path.points = points


func update_ambulances(delta: float):
	for amb in _ambulances:
		amb.update_amb(delta)

func is_position_above_ambulance(pos: Vector2) -> bool:
	var MAX_DIST_SQ = pow((GlobalConstants.TILE_SIZE * 0.5), 2.0)
	for amb in _ambulances:
		var dist = amb.get_global_position().distance_squared_to(pos)
		if dist < MAX_DIST_SQ:
			return true
	return false

func spawn_random_heart():
	var pos = Rng.rand_array_element(road_world_positions)
	_spawn_heart(pos)

# world_pos -> world_pos
func get_nav_path(world_pos_from: Vector2, world_pos_to: Vector2) -> PoolVector2Array:
	var grid_pos_from = roads.world_to_map(world_pos_from)
	var grid_pos_to = roads.world_to_map(world_pos_to)
	var points = grid_navigation.get_nav_path(grid_pos_from, grid_pos_to)
	# Remove first point
#	points.remove(0)
	for i in range(len(points)):
		points[i] = GlobalConstants.grid_to_world(points[i])
	return points


func _spawn_heart(pos: Vector2):
	var new_heart = heart_prefab.instance()
	add_child(new_heart)
	_hearts[pos] = new_heart
	new_heart.connect("collected", self, "_on_heart_collected")
	new_heart.initialize(pos)

func _on_ambulance_selected(amb) -> void:
	if selected_ambulance:
		selected_ambulance.set_selected(false)
	amb.set_selected(true)
	selected_ambulance = amb

func _on_heart_collected(heart) -> void:
	_hearts.erase(heart)
	print("heart collected")

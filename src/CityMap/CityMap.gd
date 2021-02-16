extends Node2D

signal heart_collected(h)
signal heart_expired(h)
signal heart_created(h)

onready var buildings = $Buildings
onready var roads = $Roads
onready var grid_navigation = $GridNavigation
onready var ambulance_slots = $AmbulanceSlots
onready var heart_animator = $HeartAnimator
onready var buildings_nice = $BuildingsNice
onready var heart_spawn_timer = $HeartSpawnTimer

onready var path = $Path
onready var pawn_contaner = self #$BuildingsNice


var ambulance_prefab = preload("res://src/CityMap/Ambulance.tscn")
var heart_prefab = preload("res://src/CityMap/Pickups/Heart.tscn")

var selected_ambulance = null

var _ambulances = []

# world_pos -> heart
var _hearts = {}

var heart_world_positions = []

var hearts_collected = 0
var hearts_expired = 0

#const BPM = 60

var _ui = null
var _day_idx = -1

func initialize(ui) -> void:
	_ui = ui
	reset()
	connect("heart_collected", ui, "_on_heart_collected")
	connect("heart_expired", ui, "_on_heart_expired")
	ui.connect("ambulance_ui_clicked", self, "_on_ambulance_ui_clicked")
	connect("heart_created", heart_animator, "_on_heart_created")
	connect("heart_collected", heart_animator, "_on_heart_collected")
	connect("heart_expired", heart_animator, "_on_heart_expired")
	buildings.visible = false
	ambulance_slots.visible = false

func start_day(day_idx) -> void:
	reset()
	_day_idx = day_idx
	heart_animator.initialize(day_idx)
	_init_city()
	_init_ambulances()
	_ui.init_gameplay(_ambulances)
	buildings_nice.visible = true
	heart_spawn_timer.wait_time = GlobalConstants.day_data(day_idx).heart_spawn_rate
	heart_spawn_timer.start()

func reset():
	path.points = PoolVector2Array()
	roads.clear()
	heart_spawn_timer.stop()
	for h in _hearts.values():
		if h != null:
			h.queue_free()
	_hearts = {}
	for a in _ambulances:
		a.queue_free()
	_ambulances = []
	buildings_nice.visible = false
	heart_animator.stop()

func update_current_path():
	var points = PoolVector2Array()
	if not selected_ambulance:
		path.points = points
		return
	points = get_nav_path(selected_ambulance.get_last_nav_position(), 
			get_global_mouse_position(), selected_ambulance.get_remaining_fuel())
	path.points = points

func update_ambulances(delta: float):
	for amb in _ambulances:
		amb.update_amb(delta)

func get_road_center_position(grid_pos) -> Vector2:
	return roads.map_to_world(grid_pos) + Vector2.DOWN * GlobalConstants.TILE_SIZE * 0.5

# world_pos -> world_pos
func get_nav_path(world_pos_from: Vector2, world_pos_to: Vector2, max_length: float) -> PoolVector2Array:
	var grid_pos_from = roads.world_to_map(world_pos_from)
	var grid_pos_to = roads.world_to_map(world_pos_to)
	var points = grid_navigation.get_nav_path(grid_pos_from, grid_pos_to)
	var length_left = max_length
	var world_points = PoolVector2Array()
	for i in range(len(points)):
		if length_left <= 0.0:
			break
		world_points.append(get_road_center_position(points[i]))
		if i > 0:
			var dist = world_points[i].distance_to(world_points[i-1])
			length_left -= dist
	return world_points

func spawn_random_heart():
	var pos = _get_random_free_position()
	_spawn_heart(pos)

func _spawn_heart(pos: Vector2):
	var new_heart = heart_prefab.instance()
	pawn_contaner.add_child(new_heart)
	_hearts[pos] = new_heart
	new_heart.connect("collected", self, "_on_heart_collected")
	new_heart.connect("expired", self, "_on_heart_expired")
	new_heart.initialize(pos, _day_idx)
	emit_signal("heart_created", new_heart)

func _init_ambulances() -> void:
	var i = 0
	for pos in ambulance_slots.get_used_cells():
		var amb = ambulance_prefab.instance()
		pawn_contaner.add_child(amb)
		_ambulances.append(amb)
		amb.connect("selected", self, "_on_ambulance_selected")
		amb.initialize(get_road_center_position(pos), self, i)
		i += 1

func _init_city() -> void:
	var building_cells = buildings.get_used_cells()
	var roads_dict = {}
	for cell_pos in building_cells:
		for dir in Math.CARDINAL_DIRECTIONS + Math.CROSS_DIRECTIONS:
			var pos = cell_pos + dir
			if buildings.get_cellv(pos) == -1:
				roads_dict[pos] = null
	for pos in roads_dict.keys():
		heart_world_positions.append(get_road_center_position(pos))
	for pos in ambulance_slots.get_used_cells():
		roads_dict[pos] = null
	var road_cells = roads_dict.keys()
	roads.generate(road_cells)
	grid_navigation.initialize(roads)

func _get_random_free_position():
	var pos = Rng.rand_array_element(heart_world_positions)
	var i = 0
	while _hearts.get(pos):
		pos = Rng.rand_array_element(heart_world_positions)
		if i > 10:
			print("HEY! Could not find free position!")
			break
		i += 1
	return pos

func _on_ambulance_selected(amb) -> void:
	if selected_ambulance:
		selected_ambulance.set_selected(false)
	if amb:
		amb.set_selected(true)
	selected_ambulance = amb

func _on_heart_collected(heart) -> void:
	_hearts.erase(heart)
	hearts_collected += 1
	emit_signal("heart_collected", heart)

func _on_heart_expired(heart) -> void:
	_hearts.erase(heart)
	hearts_expired += 1
	emit_signal("heart_expired", heart)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo:
			for i in range(len(_ambulances)):
				if event.scancode == KEY_1 + i:
					_select_ambulance_by_id(i)

func _on_ambulance_ui_clicked(idx):
	_select_ambulance_by_id(idx)

func _select_ambulance_by_id(idx):
	if idx < 0 or idx >= len(_ambulances):
		print("HEY! Trying to select ambulance idx %s" %idx)
		return
	if _ambulances[idx].fsm.current_state.name != "BackToGarage":
		_ambulances[idx].select()

func _on_HeartSpawnTimer_timeout():
	spawn_random_heart()

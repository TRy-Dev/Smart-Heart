extends Node2D

onready var sprite = $Area2D/Sprite
onready var path_line = $Path
onready var area_2d = $Area2D
onready var fsm = $StateMachine

signal clicked(amb)
signal fuel_updated(fuel)

const START_FUEL := 100.0
const SPEED := 50.0

var _fuel := START_FUEL
var current_path := PoolVector2Array()
var _home_position := Vector2()
var _city_map = null

var is_selected = false

func initialize(pos, city_map):
	_city_map = city_map
	area_2d.global_position = pos
	_home_position = pos
	set_selected(false)
	fsm.connect("state_changed", $Area2D/StateNameDisplay, "_on_state_changed")
	connect("fuel_updated", $Area2D/FuelDisplay, "_on_fuel_updated")
	fsm.initialize()
	set_fuel(START_FUEL)

func update_amb(delta) -> void:
	fsm.update({
		"delta": delta,
	})

func get_global_position():
	return area_2d.global_position

func update_global_position(delta: Vector2) -> void:
	area_2d.global_position += delta

func get_last_nav_position() -> Vector2:
	if len(current_path) < 2:
		return get_global_position()
	return current_path[len(current_path) - 1]

func set_selected(value: bool) -> void:
	if value:
		sprite.modulate.a = 1.0
	else:
		sprite.modulate.a = 0.5
	is_selected = value

func has_current_path() -> bool:
	return len(current_path) > 1

func get_current_move_direction() -> Vector2:
	if has_current_path():
		var dir = (current_path[1] - get_global_position()).normalized()
		if dir == Vector2.ZERO:
			_pop_closest_point()
			return get_current_move_direction()
		return dir
	else:
		return Vector2.ZERO

func distance_to_next_point() -> float:
	if len(current_path) < 2:
		return 0.0
	return get_global_position().distance_to(current_path[1])

func _pop_closest_point() -> void:
	if len(current_path) > 0:
		current_path.remove(0)

func submit_path_to_mouse() -> void:
	var path = _city_map.get_nav_path(get_last_nav_position(), get_global_mouse_position(), get_remaining_fuel())
	current_path.append_array(path)

func force_refuel_path():
	current_path = _city_map.get_nav_path(get_global_position(), _home_position, 999999)

func force_path_to(pos: Vector2):
	current_path = _city_map.get_nav_path(get_global_position(), pos, get_remaining_fuel())

func force_path_to_mouse():
	force_path_to(get_global_mouse_position())

func refuel():
	set_fuel(START_FUEL)

func update_fuel_delta(delta: float) -> void:
	set_fuel(_fuel + delta)

func set_fuel(val: float) -> void:
	_fuel = clamp(val, 0.0, START_FUEL)
	emit_signal("fuel_updated", _fuel)

func get_fuel() -> float:
	return _fuel

func get_remaining_fuel() -> float:
	var path_length = 0.0
	for i in range(1, len(current_path)):
		path_length += current_path[i].distance_to(current_path[i-1])
	return _fuel - path_length

func update_path_line() -> void:
	if len(current_path) > 0:
		current_path[0] = area_2d.global_position
	path_line.points = current_path

func is_on_home_position() -> bool:
	return get_global_position().distance_squared_to(_home_position) < Math.EPSILON

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("clicked", self)

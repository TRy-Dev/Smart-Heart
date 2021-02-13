extends Node

class_name GridNavigation

signal nav_grid_updated(a_star)

var a_star := AStar2D.new()

# Vector2 -> int
var _nav_map := {}

func _ready():
	pass
	connect("nav_grid_updated", $DebugGridNavigation, "_on_nav_grid_updated")

func initialize(walkable: TileMap) -> void:
	var cells = walkable.get_used_cells()
	if len(cells) > a_star.get_point_capacity():
		a_star.reserve_space(len(cells))
	for pos in cells:
		# Add point
		var p_id = a_star.get_available_point_id()
		a_star.add_point(p_id, pos)
		_nav_map[pos] = p_id
		# Add connections to left and up neighbours
		var neighbors = [Vector2(pos.x - 1, pos.y), Vector2(pos.x, pos.y - 1)]
		for n_pos in neighbors:
			if walkable.get_cellv(n_pos) > -1:
				var n_id = _get_point_at(n_pos, false)
				a_star.connect_points(p_id, n_id)
	emit_signal("nav_grid_updated", a_star)

func get_nav_path(pos_from: Vector2, pos_to: Vector2) -> Array:
#	return []
	var id_from = _get_point_at(pos_from, false)
	var id_to = _get_point_at(pos_to, false)
	var path = a_star.get_point_path(id_from, id_to)
	return path

func set_node_at_disabled(pos: Vector2, value: bool) -> void:
	var pt = _get_point_at(pos, true)
	a_star.set_point_disabled(pt, value)
	emit_signal("nav_grid_updated", a_star)

func _get_point_at(pos: Vector2, include_disabled: bool) -> int:
#	# Here we assume that pos exists, because pawns will move only on nav points
#	return _nav_map[pos]
	# Safer version
	if _nav_map.has(pos):
		return _nav_map[pos]
	else:
		return a_star.get_closest_point(pos, include_disabled)

## GOLF Specific code - should be moved to inheriting class?

func _on_pawn_created(index, pos) -> void:
	var pt = _get_point_at(pos, false)
	a_star.set_point_disabled(pt, true)
	emit_signal("nav_grid_updated", a_star)

func _on_pawn_destroyed(index, pos) -> void:
	var pt = _get_point_at(pos, true)
	a_star.set_point_disabled(pt, false)
	emit_signal("nav_grid_updated", a_star)

func _on_pawn_moved(index, pos_from, pos_to) -> void:
	var pt_from = _get_point_at(pos_from, true)
	var pt_to = _get_point_at(pos_to, false)
	a_star.set_point_disabled(pt_from, false)
	a_star.set_point_disabled(pt_to, true)
	emit_signal("nav_grid_updated", a_star)


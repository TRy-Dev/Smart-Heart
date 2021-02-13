extends Node2D

var nav_points := []

export(Resource) var font_resource

var disabled = true

func _ready():
	set_disabled(true)

func _draw():
	for c in get_children():
		c.free()
	for point in nav_points:
		draw_circle(point.position, 1.0, Color.red if point.disabled else Color.green)
		if not point.disabled:
			for neigh_pos in point.neighbors:
				draw_line(point.position, neigh_pos, Color.blue)

func set_disabled(value: bool) -> void:
	disabled = value
	visible = not value

func _process(delta):
	if Input.is_action_just_pressed("toggle_debug"):
		set_disabled(not disabled)

func _update_nav(a_star):
	nav_points = []
	var tile_size = GlobalConstants.TILE_SIZE
	for p_id in a_star.get_points():
		var point := {}
		var pos_grid = a_star.get_point_position(p_id)
		var pos_world = tile_size * (pos_grid + 0.5 * Vector2.ONE)
		point["position"] = pos_world
		point["grid_pos"] = pos_grid
		point["disabled"] = a_star.is_point_disabled(p_id)
		var neighbor_points = []
		for conn_id in a_star.get_point_connections(p_id):
			if a_star.is_point_disabled(conn_id):
				continue
			var neigh_pos_grid = a_star.get_point_position(conn_id)
			var neigh_pos_world = tile_size * (neigh_pos_grid + 0.5 * Vector2.ONE)
			neighbor_points.append(neigh_pos_world)
		point["neighbors"] = neighbor_points
		
		nav_points.append(point)
	update()

func _on_nav_grid_updated(a_star):
	if disabled:
		return
	_update_nav(a_star)


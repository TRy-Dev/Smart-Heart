extends Node2D
# https://natureofcode.com/book/chapter-6-autonomous-agents/

class_name FlowField

export(int, 10, 1000) var resolution := 10
export(int, 0.1, 100.0) var zoom := 1.0
export(bool) var inner_edges := false

export(PackedScene) var flow_vector_scene

var cols := 0
var rows := 0
var field_size := Vector2()
var field = [[]]

func _ready() -> void:
	field_size = 2.0 * $Shape.shape.extents
	resolution = min(resolution, field_size.x)
	resolution = min(resolution, field_size.y)
	cols = field_size.x / resolution
	rows = field_size.y / resolution
	init()

func init() -> void:
	for y in range(rows):
		field.append([])
		for x in range(cols):
			var v_pos = grid_to_world(Vector2(x, y))
			if inner_edges and (x == 0 or x == cols-1 or y == 0 or y == rows-1):
				var dir = (global_position - v_pos).normalized()
				field[y].append(dir)
			else:
				var theta = Math.map(Rng.noise(x * zoom, y * zoom), 0 , 1, 0, 2 * PI)
				field[y].append(Vector2(cos(theta), sin(theta)))
			_spawn_vector(v_pos, field[y][x])

func grid_to_world(pos: Vector2) -> Vector2:
	var offset = global_position - 0.5 * field_size
	var world_pos = offset + Vector2(pos.x, pos.y) * resolution + 0.5 * Vector2.ONE * resolution
	return world_pos

func world_to_grid(pos: Vector2) -> Vector2:
	var local_pos = pos - global_position + 0.5 * field_size
	var grid_pos = (local_pos / resolution).floor()
	return grid_pos

func lookup(pos: Vector2) -> Vector2:
	var grid_pos = world_to_grid(pos)
	if grid_pos.x < 0 or grid_pos.y < 0 or grid_pos.x > cols-1 or grid_pos.y > rows-1:
		return Vector2()
	return field[grid_pos.y][grid_pos.x]

func _spawn_vector(pos: Vector2, dir: Vector2) -> void:
	var v = flow_vector_scene.instance()
	add_child(v)
	v.init(pos, dir)

extends Node2D

onready var _ground :TileMap = $Ground
onready var _decoratives :TileMap = $Decoratives
onready var _border_colliders :TileMap = $BorderColliders
onready var _background :TileMap = $Background

const BACKGROUND_PADDING = 32

# Ground:
# 	NOT on inner,manual collider
# Decorative:
#	randomly on ground
# Border colliders:
#	around ground
# Background (around playable area):
# 	In visible area, 
# 	NOT on ground, collider

func _ready():
	initialize()
	_ground.modulate = Color8(71, 45, 60) #Colors.get_color("black")

func initialize() -> void:
	var ground_cells = _ground.get_used_cells()
	var borders = {}
	for cell_pos in ground_cells:
		for dir in Math.CARDINAL_DIRECTIONS: # + Math.CROSS_DIRECTIONS:
			var pos = cell_pos + dir
			if _ground.get_cellv(pos) == -1:
				borders[pos] = null
	var border_cells = borders.keys()
	var BIG_NUMBER = pow(10, 8)
	var min_pos = Vector2(BIG_NUMBER, BIG_NUMBER)
	var max_pos = Vector2(-BIG_NUMBER, -BIG_NUMBER)
	for pos in border_cells:
		if pos.x > max_pos.x:
			max_pos.x = pos.x
		elif pos.x < min_pos.x:
			min_pos.x = pos.x
		if pos.y > max_pos.y:
			max_pos.y = pos.y
		elif pos.y < min_pos.y:
			min_pos.y = pos.y
	var background_cells = []
	for y in range(min_pos.y - BACKGROUND_PADDING, max_pos.y + BACKGROUND_PADDING):
		for x in range(min_pos.x - BACKGROUND_PADDING, max_pos.x + BACKGROUND_PADDING):
			var pos = Vector2(x, y)
			if _ground.get_cellv(pos) == -1 and not borders.has(pos):
				background_cells.append(pos)
	_decoratives.generate(ground_cells)
	_border_colliders.generate(border_cells)
	_background.generate(background_cells)

func get_walkable_tilemap() -> TileMap:
	return _ground

func is_position_walkable(pos: Vector2) -> bool:
	return _ground.get_cellv(pos) > -1

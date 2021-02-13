extends Node2D

onready var buildings = $Buildings
onready var roads = $Roads
onready var grid_navigation = $GridNavigation

func initialize() -> void:
	var building_cells = buildings.get_used_cells()
	var roads_dict = {}
	for cell_pos in building_cells:
		for dir in Math.CARDINAL_DIRECTIONS + Math.CROSS_DIRECTIONS:
			var pos = cell_pos + dir
			if buildings.get_cellv(pos) == -1:
				roads_dict[pos] = null
	var road_cells = roads_dict.keys()
	roads.generate(road_cells)
	grid_navigation.initialize(roads)

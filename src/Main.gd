extends Node2D

onready var city_map = $CityMap

func _ready():
	city_map.initialize()

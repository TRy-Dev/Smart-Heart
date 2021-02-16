extends Node2D

onready var city_map = $CityMap
onready var ui = $UserInterface

enum GameStates {
	DayIntro,
	MapGameplay,
}

const START_STATE = GameStates.DayIntro

var current_day = 0

func _ready():
#	pass
	city_map.initialize(ui)

func _process(delta):
	city_map.update_current_path()
	city_map.update_ambulances(delta)
	if Input.is_action_just_pressed("debug_restart"):
		SceneController.reload_current()

func _on_HeartSpawnTimer_timeout():
	city_map.spawn_random_heart()

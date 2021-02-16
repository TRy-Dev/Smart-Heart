extends Node2D

onready var city_map = $CityMap
onready var ui = $UserInterface
onready var gameplay_timer = $GameplayTimer

enum GameStates {
	DayIntro,
	MapGameplay,
}

const START_STATE = GameStates.DayIntro
const GAMEPLAY_DURATION = 5.0

var current_day = -1
var current_state = -1

var total_hearts_collected = 0
var total_hearts_expired = 0

func _ready():
	gameplay_timer.wait_time = GAMEPLAY_DURATION
	gameplay_timer.one_shot = true
	ui.initialize(self)
	city_map.initialize(ui)
	_set_state(START_STATE)

func _process(delta):
	_update_state(delta)
	if Input.is_action_just_pressed("debug_restart"):
		SceneController.reload_current()

func _set_state(state: int) -> void:
	current_state = state
	match state:
		GameStates.DayIntro:
			current_day += 1
			ui.show_story(current_day)
			city_map.reset()
		GameStates.MapGameplay:
			ui.show_map()
			city_map.start_day(current_day)
			gameplay_timer.start()

func _update_state(delta: float):
	match current_state:
		GameStates.DayIntro:
			pass
		GameStates.MapGameplay:
			city_map.update_current_path()
			city_map.update_ambulances(delta)

func _on_start_button_pressed():
	# Start current Gameplay Day
	if current_state == GameStates.MapGameplay:
		print("HEY! Trying to set the same state! (GAMEPLAY)")
		return
	_set_state(GameStates.MapGameplay)

func _on_GameplayTimer_timeout():
	# End current Gameplay Day
	if current_state == GameStates.DayIntro:
		print("HEY! Trying to set the same state! (INTRO)")
		return
	total_hearts_collected += city_map.hearts_collected
	total_hearts_expired += city_map.hearts_expired
	print("In day %s\nCollected: %s\nExpired: %s" 
			%[current_day, city_map.hearts_collected, city_map.hearts_expired])
	print("Total\nCollected: %s\nExpired: %s"
			%[total_hearts_collected, total_hearts_expired])
	_set_state(GameStates.DayIntro)

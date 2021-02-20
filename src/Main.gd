extends Node2D

onready var city_map = $CityMap
onready var ui = $UserInterface
onready var gameplay_timer = $GameplayTimer
onready var camera_controller = $CameraController

enum GameStates {
	DayIntro,
	MapGameplay,
}

const START_STATE = GameStates.DayIntro
const GAMEPLAY_DURATION = 60.0
const AFTER_GAMEPLAY_DELAY = 2.0

var current_day = -1
var current_state = -1

func _ready():
	gameplay_timer.one_shot = true
	ui.initialize(self)
	city_map.connect("heart_expired", self, "_on_heart_destroyed")
	city_map.connect("heart_expired", self, "_on_heart_expired")
	city_map.connect("heart_collected", self, "_on_heart_destroyed")
	city_map.initialize(ui)
	_set_state(START_STATE)

func _process(delta):
	_update_state(delta)

func _set_state(state: int) -> void:
	current_state = state
	match state:
		GameStates.DayIntro:
			current_day += 1
			ui.show_story(current_day)
			yield(get_tree().create_timer(1.0), "timeout")
			city_map.reset()
		GameStates.MapGameplay:
			ui.show_map()
			city_map.start_day(current_day)
			gameplay_timer.wait_time = GAMEPLAY_DURATION + GlobalConstants.day_data(current_day).start_delay
			gameplay_timer.start()
			camera_controller.set_zoom_level("far", false)
			camera_controller.set_zoom_level("close")

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
	city_map.stop_spawning_hearts()
	if city_map.heart_count() <= 0 and current_state == GameStates.MapGameplay:
		_complete_gameplay()

func _on_heart_destroyed(h) -> void:
	# Collected or expired
	if gameplay_timer.is_stopped() and current_state == GameStates.MapGameplay:
		if city_map.heart_count() <= 0:
			_complete_gameplay()

func _on_heart_expired(h) -> void:
	camera_controller.add_trauma(0.2)
	Courtain.play("flash")
	Crt.play("glitch")

func _complete_gameplay():
	yield(get_tree().create_timer(AFTER_GAMEPLAY_DELAY), "timeout")
	if current_state == GameStates.DayIntro:
		print("HEY! Trying to set the same state! (INTRO)")
		return
	GlobalConstants.total_hearts_collected += city_map.hearts_collected
	GlobalConstants.total_hearts_expired += city_map.hearts_expired
	print("In day %s\nCollected: %s\nExpired: %s" 
			%[current_day, city_map.hearts_collected, city_map.hearts_expired])
	print("Total\nCollected: %s\nExpired: %s"
			%[GlobalConstants.total_hearts_collected, GlobalConstants.total_hearts_expired])
	if GlobalConstants.has_next_day(current_day):
		_set_state(GameStates.DayIntro)
	else:
		$EndSceneTransition.start()

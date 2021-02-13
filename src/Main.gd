extends Node2D

onready var city_map = $CityMap

func _ready():
	city_map.initialize()

func _process(delta):
	city_map.update_current_path()
#	if Input.is_action_just_pressed("rmb"):
##		if not city_map.is_position_above_ambulance(get_global_mouse_position()):
#		city_map.submit_path()
	city_map.update_ambulances(delta)
	
	if Input.is_action_just_pressed("debug_restart"):
		SceneController.reload_current()

func _on_HeartSpawnTimer_timeout():
	pass
	city_map.spawn_random_heart()

#func _unhandled_input(event):
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT and event.pressed:
#			print("unhandled click")
			




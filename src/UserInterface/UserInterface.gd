extends CanvasLayer

signal ambulance_ui_clicked(index)

onready var map_ui = $Control/MapUI/
onready var ambulance_container = $Control/MapUI/VBoxContainer
onready var hearts_picked = $Control/MapUI/VBoxContainer/HeartsContainer/HeartsPicked
onready var hearts_expired = $Control/MapUI/VBoxContainer/HeartsContainer/HeartsExpired

onready var story_ui = $Control/StoryUI

var amb_ui_prefab = preload("res://src/UserInterface/AmbulanceUI.tscn")
var heart_ui_prefab = preload("res://src/UserInterface/HeartUI.tscn")

var _ambulance_uis = []

func _ready():
	_clear_hearts()

func initialize(main):
	story_ui.connect("start_button_pressed", main, "_on_start_button_pressed")

func init_gameplay(ambulances) -> void:
	for a_ui in _ambulance_uis:
		a_ui.queue_free()
	_ambulance_uis = []
	for i in range(len(ambulances)):
		var amb = ambulances[i]
		var amb_ui = amb_ui_prefab.instance()
		ambulance_container.add_child(amb_ui)
		ambulance_container.move_child(amb_ui, i)
		_ambulance_uis.append(amb_ui)
		amb_ui.initialize(amb, i)
		amb_ui.connect("ambulance_ui_clicked", self, "_on_ambulance_ui_clicked")
	for h in hearts_picked.get_children():
		h.queue_free()
	for h in hearts_expired.get_children():
		h.queue_free()

func show_story(current_day):
	story_ui.show_story(current_day)
	map_ui.hide()

func show_map():
	map_ui.show()
	story_ui.hide()

func _add_heart(parent) -> void:
	var new_h = heart_ui_prefab.instance()
	parent.add_child(new_h)

func _clear_hearts():
	for c in hearts_picked.get_children():
		c.queue_free()
	for c in hearts_expired.get_children():
		c.queue_free()

func _on_heart_collected(h) -> void:
	_add_heart(hearts_picked)

func _on_heart_expired(h) -> void:
	_add_heart(hearts_expired)

func _on_ambulance_ui_clicked(idx):
	emit_signal("ambulance_ui_clicked", idx)

extends CanvasLayer

signal ambulance_ui_clicked(index)

onready var collected_counter = $Control/MapUI/VBoxContainer/Collected
onready var expired_counter = $Control/MapUI/VBoxContainer/Expired
onready var time_counter =  $Control/MapUI/VBoxContainer/Time
onready var map_ui = $Control/MapUI/VBoxContainer
onready var hearts_picked = $Control/MapUI/VBoxContainer/HeartsContainer/HeartsPicked
onready var hearts_expired = $Control/MapUI/VBoxContainer/HeartsContainer/HeartsExpired

var time = 0

var amb_ui_prefab = preload("res://src/UserInterface/AmbulanceUI.tscn")
var heart_ui_prefab = preload("res://src/UserInterface/HeartUI.tscn")

func _ready():
	_clear_hearts()
#	_on_heart_collected(null, 0)
#	_on_heart_expired(null, 0)

func _process(delta):
	time += delta
	_on_time_updated(time)

func init_ambulances(ambulances) -> void:
	for i in range(len(ambulances)):
		var amb = ambulances[i]
		var amb_ui = amb_ui_prefab.instance()
		map_ui.add_child(amb_ui)
		map_ui.move_child(amb_ui, i)
		amb_ui.initialize(amb, i)
		amb_ui.connect("ambulance_ui_clicked", self, "_on_ambulance_ui_clicked")

func _add_heart(parent) -> void:
	var new_h = heart_ui_prefab.instance()
	parent.add_child(new_h)

func _clear_hearts():
	for c in hearts_picked.get_children():
		c.queue_free()
	for c in hearts_expired.get_children():
		c.queue_free()

func _on_heart_collected(h, count) -> void:
	collected_counter.text = str(count)
	_add_heart(hearts_picked)

func _on_heart_expired(h, count) -> void:
	expired_counter.text = str(count)
	_add_heart(hearts_expired)

func _on_time_updated(t) -> void:
	time_counter.text = str(stepify(t, 0.1))

func _on_ambulance_ui_clicked(idx):
	emit_signal("ambulance_ui_clicked", idx)

extends PanelContainer

signal ambulance_ui_clicked(index)

onready var ambulance_container = $VBoxContainer
onready var hearts_picked = $VBoxContainer/HeartsContainer/HeartsPicked
onready var hearts_expired = $VBoxContainer/HeartsContainer/HeartsExpired

var amb_ui_prefab = preload("res://src/UserInterface/AmbulanceUI.tscn")
var heart_ui_prefab = preload("res://src/UserInterface/HeartUI.tscn")

var _ambulance_uis = []

func _ready():
	_clear_hearts()

func init_gameplay(ambulances) -> void:
	for a_ui in _ambulance_uis:
		a_ui.queue_free()
	_ambulance_uis = []
	for i in range(len(ambulances)):
		var amb = ambulances[i]
		var amb_ui = amb_ui_prefab.instance()
		ambulance_container.add_child(amb_ui)
		ambulance_container.move_child(amb_ui, i + 1)
		_ambulance_uis.append(amb_ui)
		amb_ui.initialize(amb, i)
		amb_ui.connect("ambulance_ui_clicked", self, "_on_ambulance_ui_clicked")
	for h in hearts_picked.get_children():
		h.queue_free()
	for h in hearts_expired.get_children():
		h.queue_free()

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

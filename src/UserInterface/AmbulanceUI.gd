extends PanelContainer

signal ambulance_ui_clicked(index)

onready var fuel_bar = $VBoxContainer/FuelBar
onready var name_label = $VBoxContainer/Container/Info/Name
onready var state_label = $VBoxContainer/Container/Info/State
onready var image = $VBoxContainer/Container/Image
onready var index_label = $VBoxContainer/Container/Index

var index = -1

#signal selected(amb)
#signal fuel_updated(fuel)
#signal position_changed(delta)

var _amb = null

func initialize(amb, idx) -> void:
	_amb = amb
	index = idx
	index_label.text = str(idx + 1)
	amb.connect("selected", self, "_on_ambulance_selected")
	amb.connect("fuel_updated", self, "_on_ambulance_fuel_updated")
	amb.connect("position_changed", self, "_on_ambulance_position_changed")
	amb.fsm.connect("state_changed", self, "_on_ambulance_state_changed")
	fuel_bar.max_value = amb.START_FUEL
	state_label.text = amb.fsm.current_state.name
	name_label.text = amb.ambulance_name
	_on_ambulance_fuel_updated(amb.get_fuel())

func _process(delta):
	if _amb != null:
		if _amb.is_selected:
			modulate.a = 1.0
		else:
			modulate.a = 0.5

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("ambulance_ui_clicked", index)

func _on_ambulance_selected(amb) -> void:
#	print(amb)
	print("Ambulance UI selected. TBI")

func _on_ambulance_fuel_updated(fuel) -> void:
	fuel_bar.value = fuel

func _on_ambulance_position_changed(delta) -> void:
#	print("Ambulance position changed. TBI")
	pass

func _on_ambulance_state_changed(previous, current) -> void:
	state_label.text = current.name

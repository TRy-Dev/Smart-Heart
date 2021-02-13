extends Label

func _on_fuel_updated(value):
	text = str(stepify(value, 1))

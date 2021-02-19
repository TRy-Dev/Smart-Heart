extends Pickup

var ambulances = []

func _on_area_entered(area):
	ambulances.append(area.owner)

func _on_Area2D_area_exited(area):
	ambulances.erase(area.owner)

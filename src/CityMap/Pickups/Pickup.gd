extends Node2D

class_name Pickup

signal collected(h)
signal expired(h)

func initialize(pos: Vector2, day_idx: int) -> void:
	global_position = pos

func _on_area_entered(area):
	print("Area of %s entered" %name)

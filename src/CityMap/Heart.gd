extends Node2D

signal collected(h)

func initialize(pos: Vector2) -> void:
	global_position = pos

func _on_Area2D_area_entered(area):
	emit_signal("collected", self)
	queue_free()

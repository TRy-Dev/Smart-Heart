extends Boid

# Spring-like offset for camera
# Set as target for CameraController

export (int, 0, 100) var max_offset_length = 20

onready var base_transform = get_parent()
var _offset = Vector2()

func set_offset(dir: Vector2, length: float) -> void:
	length = clamp(length, 0.0, 1.0)
	dir = dir.normalized()
	_offset = dir * length * max_offset_length

func update() -> void:
	apply_force(arrive(base_transform.global_position + _offset))
	.update()

# Temporary

func force_reset_offset() -> void:
	set_offset(Vector2.ZERO, 0.0)
	while position.length_squared() > Math.EPSILON:
		update()
		yield(get_tree(), "idle_frame")
	position = Vector2.ZERO

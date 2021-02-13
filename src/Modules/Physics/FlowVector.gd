extends Line2D

func init(pos: Vector2, dir: Vector2):
	global_position = pos
	rotation_degrees = rad2deg(dir.angle())

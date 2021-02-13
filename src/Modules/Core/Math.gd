extends Node

const EPSILON = 0.0001

const CARDINAL_DIRECTIONS = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
const CROSS_DIRECTIONS = [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)]

# https://forum.processing.org/one/topic/recreate-map-function.html
func map(value, istart, istop, ostart, ostop):
	return ostart + (ostop - ostart) * ((value - istart) / (istop - istart))

func is_vector_cardinal(vec: Vector2) -> bool:
	vec = vec.normalized()
	for card in CARDINAL_DIRECTIONS:
		if vec.is_equal_approx(card):
			return true
	return false

extends Node

var _rng = RandomNumberGenerator.new()
var _noise = OpenSimplexNoise.new()

# Does not work with max int values for some reason
# https://docs.godotengine.org/en/stable/classes/class_int.html
const MIN_INT = -999999999999 # -9223372036854775808
const MAX_INT = 999999999999 # 9223372036854775807

func _init():
	_rng.randomize()
#	_noise.seed = self.randi()

func randf(from = 0.0, to = 1.0) -> float:
	return _rng.randf_range(from, to)

func randi(from = MIN_INT, to = MAX_INT) -> int:
	return _rng.randi_range(from, to)

func randv(v_from, v_to) -> Vector2:
	return Vector2(self.randi(v_from.x, v_to.x), self.randi(v_from.y, v_to.y))

func rand_rgb() -> Color:
	return Color(self.randf(0.0, 1.0), self.randf(0.0, 1.0), self.randf(0.0, 1.0))

func rand_array_element(array: Array):
	return array[self.randi(0, len(array)-1)]

func noise(x:=0, y:=0, z:=0, w:=0) -> float:
	var noise = _noise.get_noise_4d(x, y, z, w)
	var mapped = Math.map(noise, -0.6, 0.6, 0.0, 1.0)
	return mapped

func noise_seed():
	return _noise.seed

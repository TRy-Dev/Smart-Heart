extends PhysicalObject2D

# Source: https://natureofcode.com/book/chapter-6-autonomous-agents/

class_name Boid

export(float, 0.0, 500.0) var slow_radius := 100.0
export(float, 0.0, 100.0) var separate_radius := 40.0

var neighbors = []

func seek(target: Vector2) -> Vector2:
	var desired = target - global_position
	desired = desired.normalized()
	desired *= max_speed
	var steer = desired - velocity
	return steer

func arrive(target: Vector2) -> Vector2:
	var desired = target - global_position
	var d = desired.length()
	desired = desired.normalized()
	if d < slow_radius:
		var m = Math.map(d, 0, slow_radius, 0, max_speed)
		desired *= m
	else:
		desired *= max_speed
	var steer = desired - velocity
	return steer

func flow(flow: FlowField) -> Vector2:
	var desired = flow.lookup(global_position)
	if desired.length_squared() < Math.EPSILON:
		return Vector2()
	desired *= max_speed
	var steer = desired - velocity
	return steer

func separate() -> Vector2:
	if not neighbors:
		return Vector2()
	var sum = Vector2()
	var count = 0
	for b in neighbors:
		var diff = global_position - b.global_position
		if diff.length_squared() < pow(separate_radius, 2.0):
			sum += diff.normalized()
			count += 1
	if not count:
		return Vector2()
	sum /= len(neighbors)
	sum *= max_speed
	var steer = sum - velocity
	return steer

func align() -> Vector2:
	if not neighbors:
		return Vector2()
	var sum = Vector2()
	for n in neighbors:
		sum += n.velocity
	sum /= len(neighbors)
	sum = sum.normalized() * max_speed
	var steer = sum - velocity
	return steer

func cohesion() -> Vector2:
	if not neighbors:
		return Vector2()
	var sum = Vector2()
	for n in neighbors:
		sum += n.position
	sum /= len(neighbors)
	return arrive(sum)

extends KinematicBody2D

class_name PhysicalObject2D

# Properties
export(float, 0.01, 100.0) var mass := 1.0
export(float, 0.0, 1.0) var friction_coeff := 0.02
export(float, 0.0, 1.0) var bounciness := 0.90

# Constraints
export(float, 0.0, 100000.0) var max_speed := 100000.0
export(float, 0.0, 100000.0) var max_force := 100000.0
export(bool) var should_rotate := false

var velocity := Vector2()
var acceleration := Vector2()

const FLOOR_NORMAL = Vector2.UP
const MIN_VELOCITY_SQ = pow(4.0, 2.0)

var previous_velocity := Vector2()

func apply_force(force: Vector2) -> void:
	force *= Engine.iterations_per_second
	acceleration += force.clamped(max_force) / mass

func get_speed_sq() -> float:
	return velocity.length_squared()

func _vel_to_force(vel: Vector2) -> Vector2:
	return vel * mass #/ pow(get_physics_process_delta_time(), 2.0)

func update() -> void:
	previous_velocity = velocity
	# Apply friction
	if friction_coeff > 0.0:
		var friction = friction_coeff
		if get_speed_sq() < MIN_VELOCITY_SQ:
			# break faster when speed is low
			friction *= 10.0
		apply_force(_vel_to_force(-1 * previous_velocity * friction))
	# Apply acceleration
	previous_velocity += acceleration * get_physics_process_delta_time()
	previous_velocity = previous_velocity.clamped(max_speed)
	velocity = move_and_slide(previous_velocity, FLOOR_NORMAL)
	# Bounce if collided
	var slide_count = get_slide_count()
	if slide_count and bounciness:
		_handle_collision(get_slide_collision(slide_count - 1))
	# Rotate if rotation enabled
	if should_rotate:#  and velocity.length_squared() >= MIN_VELOCITY_SQ:
		rotation = lerp(rotation, velocity.angle(), 0.2) #look_at(global_position + velocity)
	# Reset acceleration
	acceleration = Vector2()

func _handle_collision(collision):
	velocity = bounciness * previous_velocity.bounce(collision.normal)

extends State

class_name PlatformerState

# Simple base state for all platformer states
# TODO:
# 1. Add horizontal acceleration and drag: https://kidscancode.org/godot_recipes/2d/platform_character/
# 2. UX - Coyote timer, jump input forgiveness
# 3. Slope handing, ...
# 4. ...

const TILE_SIZE = 64
const TILE_PADDED = TILE_SIZE + 0

export(int, 0, 1000) var max_jump_height := TILE_PADDED * 2.0
export(int, 0, 1000) var min_jump_height := TILE_PADDED * 1.2
export(int, 0, 1000) var jump_distance := TILE_PADDED * 4
export(int, 0, 1000) var walk_speed := TILE_SIZE * 4

# Calculated variables
var vel_gravity := 0.0
var max_jump_speed := 0.0
var min_jump_speed := 0.0

func initialize() -> void:
	jump_distance *= 0.5
	vel_gravity = (2 * max_jump_height * pow(walk_speed, 2.0)) / (pow(jump_distance, 2.0) * Engine.iterations_per_second)
	max_jump_speed = -2 * max_jump_height * walk_speed / jump_distance #-sqrt(2 * gravity * max_jump_height)
	min_jump_speed = -2 * min_jump_height * walk_speed / jump_distance

func get_velocity() -> Vector2:
	return owner.velocity

func set_velocity(velocity: Vector2, reset_x: bool, reset_y :bool) -> void:
	if reset_x:
		owner.velocity.x = velocity.x
	else:
		owner.velocity.x += velocity.x
	if reset_y:
		owner.velocity.y = velocity.y
	else:
		owner.velocity.y += velocity.y

func stop_jump() -> void:
	if get_velocity().y < 0:
		owner.velocity.y = max(owner.velocity.y, min_jump_speed)

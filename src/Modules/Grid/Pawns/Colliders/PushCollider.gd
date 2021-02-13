extends DynamicCollider

export(float, 0.0, 50.0) var push_force = 5.0

var target = null

func _physics_process(delta):
	if target:
		var push_dir = (target.global_position - global_position).normalized()
		target.apply_force(push_dir * push_force)

func _on_body_entered(body):
	if body is Player:
		AudioController.sfx.play_at("wall_hit", global_position)
		target = body

func _on_body_exited(body):
	if body is Player:
		target = null

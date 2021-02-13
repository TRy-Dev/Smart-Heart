extends Node

var _particles = {
#	"dust": preload("res://src/Modules/Rendering/Particles/Dust.tscn"),
#	"blood": preload("res://src/Modules/Rendering/Particles/Blood.tscn"),
}

func play(name, position): 
	if not name in _particles:
		push_error("HEY! Trying to play nonexistant particle: %s" %name) 
		return
	_create_particle(name, position)

func _create_particle(name, position):
#	print("Particle %s created at %s" %[name, position])
	var new_particle = _particles[name].instance()
	add_child(new_particle)
	new_particle.global_position = position
	new_particle.emitting = true
	yield(get_tree().create_timer(new_particle.lifetime), "timeout")
	new_particle.queue_free()

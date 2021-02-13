extends Boid

class_name Flocker

export(float, 0.0, 10.0) var sep_mult := 1.0
export(float, 0.0, 10.0) var ali_mult := 1.0
export(float, 0.0, 10.0) var coh_mult := 1.0

func flock() -> void:
	var sep = separate()
	var ali = align()
	var coh = cohesion()
	apply_force(sep * sep_mult)
	apply_force(ali * ali_mult)
	apply_force(coh * coh_mult)

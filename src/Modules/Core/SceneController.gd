extends Node

signal scene_started_loading(scene)
signal scene_finished_loading(scene)

func load_scene(scene):
	emit_signal("scene_started_loading", scene)
	get_tree().change_scene_to(scene)
	emit_signal("scene_finished_loading", scene)

func load_scene_by_path(path):
	var scene = load(path)
	emit_signal("scene_started_loading", scene)
	get_tree().change_scene_to(scene)
	emit_signal("scene_finished_loading", scene)

func reload_current():
	get_tree().reload_current_scene()

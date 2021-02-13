# Saves and loads savegame files
# Each node is responsible for finding itself in the save_game
# dict so saves don't rely on the nodes' path or their source file
extends Node

const SAVE_TEMPLATE = preload('res://src/Modules/DataPersistence/GameSave.gd')
const SAVE_FOLDER: String = "res://debug/save"
const SAVE_NAME_TEMPLATE: String = "save_%03d.tres"
const SAVE_GROUP = 'save'

func save_game(id: int):
	# Passes a SaveGame resource to all nodes to save data from
	# and writes it to the disk
	var save := SAVE_TEMPLATE.new()
	# not available in Godot 3.2.3
#	save.game_version = ProjectSettings.get_setting("application/config/version") 
	for node in get_tree().get_nodes_in_group(SAVE_GROUP):
		node.save_state(save)
	var directory: Directory = Directory.new()
	if not directory.dir_exists(SAVE_FOLDER):
		directory.make_dir_recursive(SAVE_FOLDER)
	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	var error: int = ResourceSaver.save(save_path, save)
	if error != OK:
		print('There was an issue writing the save %s to %s' % [id, save_path])
	print("Game Saved: %s" % id)

func load_game(id: int):
	# Reads a saved game from the disk and delegates loading
	# to the individual nodes to load
	var save_file_path: String = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	var file: File = File.new()
	if not file.file_exists(save_file_path):
		print("Save file %s doesn't exist" % save_file_path)
		return
	var save: Resource = load(save_file_path)
	for node in get_tree().get_nodes_in_group(SAVE_GROUP):
		node.load_state(save)
	print("Game Loaded: %s" % id)

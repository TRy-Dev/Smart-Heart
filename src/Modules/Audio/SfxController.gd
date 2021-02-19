extends Node

onready var _sources_0d = $Sources
onready var _sources_2d = $Sources2D

var _clips := {}

const MAX_AUDIO_SOURCES := 8
const MIN_PITCH := 0.95
const MAX_PITCH := 1.05
const SFX_PATH := "res://assets/audio/sfx"

const SOURCE_2D_MAX_DISTANCE := 200.0
const SOURCE_2D_ATTENUATION := 2.0

const VOLUME_DB = -15

func _init():
	self.load()

func play(name: String, volume_db := 0) -> void:
	if not name in _clips:
		push_error("HEY! No such audio clip: %s" %name)
		return
	var source = _get_idle_source(_sources_0d, AudioStreamPlayer)
	_play_audio(source, name, volume_db)

func play_at(name: String, position: Vector2) -> void:
	if not name in _clips:
		push_error("HEY! No such audio clip: %s" %name)
		return
	var source = _get_idle_source(_sources_2d, AudioStreamPlayer2D)
	if source:
		source.global_position = position
		_play_audio(source, name)

func _get_idle_source(sources_parent, template):
	var sources = sources_parent.get_children()
	for source in sources:
		if not source.playing:
			return source
	if len(sources) < MAX_AUDIO_SOURCES:
		var new_source = template.new()
		new_source.bus = "Sfx"
		new_source.volume_db = VOLUME_DB
		sources_parent.add_child(new_source)
		if template == AudioStreamPlayer2D:
			new_source.max_distance = SOURCE_2D_MAX_DISTANCE
			new_source.attenuation = SOURCE_2D_ATTENUATION
		return new_source
	else:
		push_error("HEY! Trying to play more than %s audio clips at the same time" % MAX_AUDIO_SOURCES)

func _play_audio(source, name: String, volume_db := 0):
	if not source:
		return
	source.stream = _clips[name][Rng.randi(0, len(_clips[name]) - 1)]
	source.pitch_scale = Rng.randf(MIN_PITCH, MAX_PITCH)
	source.volume_db = clamp(volume_db, -80, 0)
	source.play()

func load():
	for dir in FileSystem.get_directories(SFX_PATH):
		_clips[dir] = []
		for f in FileSystem.get_files(FileSystem.concat_path([SFX_PATH, dir])):
			if f.ends_with(".wav"):
				var clip = load(FileSystem.concat_path([SFX_PATH, dir, f]))
				_clips[dir].append(clip)
		if not _clips[dir]:
			_clips.erase(dir)

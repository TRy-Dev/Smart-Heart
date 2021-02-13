extends Node

onready var _audio_player :AudioStreamPlayer = $AudioStreamPlayer

var _songs = {}

const SONGS_PATH = "res://assets/audio/music"

func _init():
	self.load()

func play(name :String = "") -> void:
	if name in _songs:
		_audio_player.stream = _songs[name]
		_play()
	elif _audio_player.stream_paused:
		_audio_player.stream_paused = false
	elif name == "":
		_play()
	else:
		push_error("HEY! No such song: %s" % name)

func pause() -> void:
	if _audio_player.playing:
		_audio_player.stream_paused = true

func stop() -> void:
	_audio_player.stop()
	_audio_player.stream_paused = false

func _play() -> void:
	_audio_player.play()

func load() -> void:
	for f in FileSystem.get_files(SONGS_PATH):
		if f.ends_with(".ogg"):
			var song_name = f.split(".")[0]
			var song_path = FileSystem.concat_path([SONGS_PATH, f])
			_songs[song_name] = load(song_path)

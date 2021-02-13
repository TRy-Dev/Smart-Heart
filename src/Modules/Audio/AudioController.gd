extends Node

onready var music = $MusicController
onready var sfx = $SfxController

## bus_idx (int) -> Tween
#var _current_tweens = {}

func set_bus_volume(name :String , volume :int) -> void:
	var bus_idx = AudioServer.get_bus_index(name)
	if bus_idx > -1:
		volume = clamp(volume, -80, 0)
		AudioServer.set_bus_volume_db(bus_idx, volume)
	else:
		push_error("HEY! Bus %s does not exist." % name)

func lerp_music_volume(volume :int, duration := 2.0) -> void:
	# Hardcoded solution for Music bus
	# Works separately from set_bus_volume (both will apply)
	if duration <= 0.0:
		music._audio_player.volume_db = volume
	else:
		var temp_tween := Tween.new()
		add_child(temp_tween)
		var current_volume_db = music._audio_player.volume_db
		temp_tween.interpolate_property(music._audio_player, "volume_db", current_volume_db, volume, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		temp_tween.start()
		yield(temp_tween, "tween_all_completed")
		temp_tween.queue_free()

#func lerp_bus_volume(name :String , volume :int, duration := 0.0) -> void:
	# Does not work, because tweening AudioServer "set_bus_volume_db"
	# Has no effect. If below workaround is applied audio issues will appear
	# Workaround: https://www.reddit.com/r/godot/comments/fpmwjx/tweening_audio_bus_volume/
	# https://github.com/godotengine/godot/issues/32882
	
#	var bus_idx = AudioServer.get_bus_index(name)
#	if bus_idx > -1:
#		volume = clamp(volume, -80, 0)
#		if _current_tweens.get(bus_idx):
#			_current_tweens[bus_idx].stop_all()
#			_current_tweens[bus_idx].queue_free()
#			_current_tweens.erase(bus_idx)
#		var temp_tween := Tween.new()
#		add_child(temp_tween)
#		var current_volume_db = AudioServer.get_bus_volume_db(bus_idx)
#		temp_tween.interpolate_method(AudioServer, "set_bus_volume_db", current_volume_db, volume, LERP_VOLUME_DURATION, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
#		temp_tween.start()
#		yield(temp_tween, "tween_all_completed")
#		temp_tween.queue_free()
#		_current_tweens.erase(bus_idx)
#	else:
#		push_error("HEY! Bus %s does not exist." % name)

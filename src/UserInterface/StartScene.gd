extends Control

onready var anim_player = $AnimationPlayer

var main_scene = preload("res://src/Main.tscn")

func _ready():
	AudioController.music.stop()
	GlobalConstants.reset_game_state()
	Courtain.play("fade_out")
	yield(Courtain.anim_player, "animation_finished")
	AnimationController.play(anim_player, "load")
	yield(anim_player, "animation_finished")
	AudioController.music.play("cyber_ambient")
	SceneController.load_scene(main_scene)

func play_welcome_audio():
	AudioController.sfx.play("ui_welcome")

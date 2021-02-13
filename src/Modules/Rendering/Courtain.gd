extends Control

onready var anim_player :AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	AnimationController.reset(anim_player)

func play(name :String, reset := false, backwards := false) -> void:
	AnimationController.play(anim_player, name, reset, backwards)

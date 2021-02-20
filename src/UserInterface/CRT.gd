extends CanvasLayer

onready var anim_player = $AnimationPlayer

func _ready():
	AnimationController.reset(anim_player)

func play(name):
	AnimationController.play(anim_player, name)

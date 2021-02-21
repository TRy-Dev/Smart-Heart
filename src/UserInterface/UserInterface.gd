extends CanvasLayer

onready var map_ui = $Control/MapUI
onready var story_ui = $Control/StoryUI
onready var anim_player = $AnimationPlayer

func _ready():
	AnimationController.reset(anim_player)

func initialize(main):
	story_ui.connect("start_button_pressed", main, "_on_start_button_pressed")

func init_gameplay(ambulances) -> void:
	map_ui.init_gameplay(ambulances)

func show_story(current_day):
#	if current_day == 0:
#		AnimationController.play(anim_player, "show_story", true, false)
#		anim_player.stop()
#	else:
	AnimationController.play(anim_player, "show_story")
	story_ui.show_story(current_day)
	map_ui.visible = false

func show_map():
	AnimationController.play(anim_player, "show_story", false, true)
	map_ui.visible = true
#	story_ui.hide()

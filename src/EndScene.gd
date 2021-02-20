extends PanelContainer

onready var post_ui = $HBoxContainer/PostContainer/PostUI
onready var collected_label = $HBoxContainer/Hearts/Collected/Label
onready var expired_label = $HBoxContainer/Hearts/Expired/Label
onready var anim_player = $AnimationPlayer

const START_SCENE_PATH = "res://src/UserInterface/StartScene.tscn"

var post_title = "SoftCorp is hiring!"
var post_text = "Join Smart Heart team and start #Saving #Lives #Today!"

func _ready():
	post_ui.modulate.a = 0.5
	post_ui.initialize(post_title, post_text)
	collected_label.text = str(GlobalConstants.total_hearts_collected)
	expired_label.text = str(GlobalConstants.total_hearts_expired)
	Courtain.play("fade_out")
	AnimationController.reset(anim_player)
	yield(Courtain.anim_player, "animation_finished")
	AnimationController.play(anim_player, "show_hearts")
	yield(anim_player, "animation_finished")
	AnimationController.play(anim_player, "show_post", false)

func _on_PostUI_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			SceneController.load_scene_by_path(START_SCENE_PATH)

func _on_PostUI_mouse_entered():
	post_ui.modulate.a = 1.0

func _on_PostUI_mouse_exited():
	post_ui.modulate.a = 0.5

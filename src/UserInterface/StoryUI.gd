extends PanelContainer

signal start_button_pressed()

onready var start_button = $VBoxContainer/CenterContainer/StartButton

onready var news_tab = $"VBoxContainer/TabContainer/news it"
onready var mail_tab = $"VBoxContainer/TabContainer/my mail"
onready var tab_container = $VBoxContainer/TabContainer

onready var mail_ui = mail_tab.get_node("HBoxContainer/MailUI")
onready var post_container = news_tab.get_node("PostContainer")

onready var anim_player = $AnimationPlayer
onready var tab_anim = $TabAnim

var post_prefab = preload("res://src/UserInterface/PostUI.tscn")

var btn_visible = false

func _ready():
	news_tab.name = _get_tab_name_string("news it")

func show_story(current_day):
	visible = true
	start_button.disabled = true
	tab_container.current_tab = 0
	mail_tab.name = _get_tab_name_string(">1< my mail")
	AnimationController.reset(anim_player)
	AnimationController.play(tab_anim, "show")
	call_deferred("_load_story_data", current_day)

func _load_story_data(day_idx):
	var knot_name = "day_%s" % day_idx
	var post_title = DialogueController.extract_text("%s.post_title" %knot_name)
	var post_text = DialogueController.extract_text("%s.post_text" %knot_name)
	var email_title = DialogueController.extract_text("%s.email_title" %knot_name)
	var email_text = DialogueController.extract_text("%s.email" %knot_name)
	mail_ui.set_mail(email_title, email_text)
	_add_post(post_title, post_text)

func _add_post(title, text):
	var new_post = post_prefab.instance()
	new_post.initialize(title, text)
	post_container.add_child(new_post)
	post_container.move_child(new_post, 0)
	post_container.visible = false
	post_container.visible = true

func _on_StartButton_pressed():
	AudioController.sfx.play("ui_select")
	emit_signal("start_button_pressed")

func _on_TabContainer_tab_changed(tab):
	AudioController.sfx.play("ui_click")
	if tab == 1 and start_button.disabled:
		mail_tab.name = _get_tab_name_string("  my mail  ")
		start_button.disabled = false
		AnimationController.play(anim_player, "show_button")

const TAB_WIDTH_CHARS = 24
func _get_tab_name_string(text) -> String:
	if len(text) >= TAB_WIDTH_CHARS:
		return text
	var padding_size = TAB_WIDTH_CHARS - len(text)
	var left_padding = int(padding_size / 2) + padding_size % 2
	var right_padding = int(padding_size / 2)
	var out = ""
	for i in range(left_padding):
		out += " "
	out += text
	for i in range(right_padding):
		out += " "
	return out

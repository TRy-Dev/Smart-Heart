extends PanelContainer

signal start_button_pressed()

onready var start_button = $VBoxContainer/StartButton

onready var news_tab = $"VBoxContainer/TabContainer/news it"
onready var mail_tab = $"VBoxContainer/TabContainer/my mail"
onready var tab_container = $VBoxContainer/TabContainer

onready var mail_ui = mail_tab.get_node("HBoxContainer/MailUI")
onready var post_container = news_tab.get_node("PostContainer")

var post_prefab = preload("res://src/UserInterface/PostUI.tscn")

func show_story(current_day):
	visible = true
	start_button.disabled = true
	tab_container.current_tab = 0
	start_button.text = "START DAY %s" %(current_day + 1)
	mail_tab.name = "[1] my mail"
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

func _on_StartButton_pressed():
	emit_signal("start_button_pressed")

func _on_TabContainer_tab_changed(tab):
	if tab == 1:
		mail_tab.name = "my mail"
		start_button.disabled = false

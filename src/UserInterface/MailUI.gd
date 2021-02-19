extends PanelContainer

onready var text_label = $VBoxContainer/RichTextLabel
onready var title_label = $VBoxContainer/MailTitle

func set_mail(title, text):
	title_label.text = title
	text_label.text = text

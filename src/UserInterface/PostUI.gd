extends PanelContainer

onready var title_label = $HBoxContainer/VBoxContainer/Label
onready var text_label = $HBoxContainer/VBoxContainer/RichTextLabel

var title = ""
var text = ""

func _ready():
	update_labels()

func update_labels():
	title_label.text = title
	text_label.text = text

func initialize(_title, _text):
	title = _title
	text = _text
	if title_label and text_label:
		update_labels()

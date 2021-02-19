extends PanelContainer

onready var title_label = $VBoxContainer/Label
onready var text_label = $VBoxContainer/RichTextLabel

var title = ""
var text = ""

func _ready():
	title_label.text = title
	text_label.text = text

func initialize(_title, _text):
	title = _title
	text = _text

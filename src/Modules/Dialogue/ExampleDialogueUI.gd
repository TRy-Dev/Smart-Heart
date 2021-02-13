extends CanvasLayer

onready var text = $Dialogue/Text
onready var button_container = $Dialogue

var buttons = []

func _ready():
	yield(get_tree(), "idle_frame")
	_update_ui(DialogueController.start_dialogue("peasant"))

func _update_ui(data: Dictionary) -> void:
	for b in buttons:
		b.queue_free()
	text.text = ""#data["text"]
	for line in data["lines"]:
		text.text += line
	for i in range(len(data["options"])):
		var opt = data["options"][i]
		var btn = Button.new()
		btn.text = opt.text
		btn.connect("pressed", self, "_option_selected", [i])
		button_container.add_child(btn)
		buttons.append(btn)
	
	if not len(data["options"]):
		text.text += "\n Dialogue has ended!"

func _option_selected(idx) -> void:
	_update_ui(DialogueController.select_option(idx))

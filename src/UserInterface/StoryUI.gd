extends PanelContainer

signal start_button_pressed()

onready var start_button = $VBoxContainer/StartButton

func show_story(current_day):
	visible = true
	start_button.text = "START DAY %s" %current_day

func hide():
	visible = false

func _on_StartButton_pressed():
	emit_signal("start_button_pressed")

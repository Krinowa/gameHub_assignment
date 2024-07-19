extends Control
@onready var check_button = $HBoxContainer/CheckButton as CheckButton
@onready var state_label = $HBoxContainer/State_Label as Label

func _ready():
	check_button.toggled.connect(on_subtitles_toggled)
	load_data()
	
func load_data() -> void:
	set_label_text(SettingsContainer.get_subtitles_set())

func set_label_text(button_pressed: bool) -> void:
	if button_pressed != true:
		state_label.text = "Off"
	else:
		state_label.text = "On"

func on_subtitles_toggled(button_pressed: bool) -> void:
	set_label_text(button_pressed)
	SettingsSignalBus.emit_on_subtitles_toggled(button_pressed)

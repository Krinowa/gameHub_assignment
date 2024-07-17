class_name OptionsMenu
extends Control

@onready var exit_button = $MarginContainer/VBoxContainer/Exit_Button


signal exit_options_menu

# Called when the node is added to the scene. It initializes the signals and sets the process to false.
func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	set_process(false)
	
# Emits the exit_options_menu signal and sets the process to false when the exit button is pressed.
func on_exit_pressed() -> void:
	exit_options_menu.emit()
	set_process(false)

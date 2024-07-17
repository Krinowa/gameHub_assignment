class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/Options_Button as Button
@onready var options_menu = $Options_Menu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer #main menu margin container

@onready var start_level = preload("res://scenes/Level2.tscn") as PackedScene

func _ready():
	handle_connecting_signals()
	
# Changes the scene to the preloaded start_level when the start button is pressed.
func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

# Hides the main menu and shows the options menu when the options button is pressed.
func on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
	
# Exits the game when the exit button is pressed.
func on_exit_pressed() -> void:
	get_tree().quit()
	
# Shows the main menu and hides the options menu when exiting the options menu.
func on_exit_options_menu() -> void:
	margin_container.visible = true
	options_menu.visible = false

# Connects the signals for the buttons and the options menu.
func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	options_button.button_down.connect(on_options_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)

class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var level_button = $MarginContainer/HBoxContainer/VBoxContainer/Level_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/Options_Button as Button
@onready var options_menu = $Options_Menu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer #main menu margin container

@export var start_level = load("res://scenes/UI/level 1/level1_game_manager.tscn") as PackedScene
@onready var level_menu = load("res://scenes/UI/level menu/level_menu.tscn") as PackedScene

func _ready():
	handle_connecting_signals()
	AudioPlayer.play_music_level()
	
# Changes the scene to the preloaded start_level when the start button is pressed.
func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	SoundFx.button_click()

func on_level_pressed() -> void:
	get_tree().change_scene_to_packed(level_menu)
	SoundFx.button_click()

# Hides the main menu and shows the options menu when the options button is pressed.
func on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
	SoundFx.button_click()
	
# Exits the game when the exit button is pressed.
func on_exit_pressed() -> void:
	get_tree().quit()
	SoundFx.button_click()
	
# Shows the main menu and hides the options menu when exiting the options menu.
func on_exit_options_menu() -> void:
	margin_container.visible = true
	options_menu.visible = false

# Connects the signals for the buttons and the options menu.
func handle_connecting_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	level_button.button_down.connect(on_level_pressed)
	options_button.button_down.connect(on_options_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)


func _on_start_button_mouse_entered():
	SoundFx.button_hover()

func _on_level_button_mouse_entered():
	SoundFx.button_hover()

func _on_options_button_mouse_entered():
	SoundFx.button_hover()

func _on_exit_button_mouse_entered():
	SoundFx.button_hover()




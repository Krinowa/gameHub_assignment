class_name LevelMenu
extends Control

@onready var level1_button = $MarginContainer/HBoxContainer/VBoxContainer/Level1_Button as Button
@onready var level2_button = $MarginContainer/HBoxContainer/VBoxContainer/Level2_Button as Button
@onready var level3_button = $MarginContainer/HBoxContainer/VBoxContainer/Level3_Button as Button

@onready var level1 = preload("res://scenes/Level1.tscn") as PackedScene
@onready var level2 = preload("res://scenes/Level2.tscn") as PackedScene
@onready var level3 = preload("res://scenes/Level3.tscn") as PackedScene

func _ready():
	handle_connecting_signals()

# Changes the scene to the preloaded start_level when the start button is pressed.
func on_level1_pressed() -> void:
	get_tree().change_scene_to_packed(level1)
	SoundFx.button_click()

func on_level2_pressed() -> void:
	get_tree().change_scene_to_packed(level2)
	SoundFx.button_click()

func on_level3_pressed() -> void:
	get_tree().change_scene_to_packed(level3)
	SoundFx.button_click()

# Connects the signals for the buttons.
func handle_connecting_signals() -> void:
	level1_button.button_down.connect(on_level1_pressed)
	level2_button.button_down.connect(on_level2_pressed)
	level3_button.button_down.connect(on_level3_pressed)


func _on_level_1_button_mouse_entered():
	SoundFx.button_hover()

func _on_level_2_button_mouse_entered():
	SoundFx.button_hover()

func _on_level_3_button_mouse_entered():
	SoundFx.button_hover()

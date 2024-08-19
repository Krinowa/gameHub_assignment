class_name LevelMenu
extends Control

@onready var level1_button = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Level1_Button as Button
@onready var level2_button = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Level2_Button as Button
@onready var level3_button = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Level3_Button as Button
@onready var level4_button = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Level4_Button as Button
@onready var back_button = $MarginContainer/HBoxContainer/VBoxContainer/Back_button as Button


@onready var level1 = load("res://scenes/UI/level 1/level1_game_manager.tscn") as PackedScene
@onready var level2 = load("res://scenes/UI/level 2/level2_game_manager.tscn") as PackedScene
@onready var level3 = load("res://scenes/UI/level 3/level3_game_manager.tscn") as PackedScene
@onready var level4 = load("res://scenes/UI/level 4/level4_game_manager.tscn") as PackedScene

@onready var back = load("res://scenes/UI/main menu/main_menu.tscn") as PackedScene


func _ready():
	handle_connecting_signals()

# Changes the scene to the preloaded start_level when the start button is pressed.
func _on_level_1_button_pressed():
	get_tree().change_scene_to_packed(level1)
	SoundFx.button_click()

func _on_level_2_button_pressed():
	get_tree().change_scene_to_packed(level2)
	SoundFx.button_click()

func _on_level_3_button_pressed():
	get_tree().change_scene_to_packed(level3)
	SoundFx.button_click()

func _on_level_4_button_pressed():
	get_tree().change_scene_to_packed(level4)
	SoundFx.button_click()

func _on_back_button_pressed():
	get_tree().change_scene_to_packed(back)
	SoundFx.button_click()

# Connects the signals for the buttons.
func handle_connecting_signals() -> void:
	level1_button.button_down.connect(_on_level_1_button_pressed)
	level2_button.button_down.connect(_on_level_2_button_pressed)
	level3_button.button_down.connect(_on_level_3_button_pressed)
	level4_button.button_down.connect(_on_level_4_button_pressed)
	back_button.button_down.connect(_on_back_button_pressed)
#!! Invalid get index 'button_down' (on base: 'null instance'). Get this error mean need to change the path of button of variable above

func _on_level_1_button_mouse_entered():
	SoundFx.button_hover()

func _on_level_2_button_mouse_entered():
	SoundFx.button_hover()

func _on_level_3_button_mouse_entered():
	SoundFx.button_hover()

func _on_level_4_button_mouse_entered():
	SoundFx.button_hover()

func _on_back_button_mouse_entered():
	SoundFx.button_hover()














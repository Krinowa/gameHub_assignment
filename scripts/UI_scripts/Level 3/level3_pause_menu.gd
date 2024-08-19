class_name Level3_PauseMenu

extends Control

@export var level3_game_manager : Level3_GameManager
@export var main_menu = load("res://scenes/UI/main menu/main_menu.tscn") as PackedScene
#! Error: Cannot call method 'connect' on a null value.-> Run on level3_game_manager 

func _ready():
	hide()
	level3_game_manager.connect("toggle_game_paused", _on_game_manager_toggle_game_paused)
	

func _process(delta):
	pass

func _on_game_manager_toggle_game_paused(is_paused : bool):
	print(is_paused)
	if(is_paused):
		show()
	else:
		hide()


func _on_resume_button_pressed():
	level3_game_manager.game_paused = false


func _on_exit_button_pressed():
	level3_game_manager.game_paused = false
	get_tree().change_scene_to_packed(main_menu)

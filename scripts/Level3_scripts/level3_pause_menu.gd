class_name Level3_PauseMenu

extends Control

@export var level3_manager : Level3_Manager
@export var main_menu = preload("res://scenes/UI/main menu/main_menu.tscn") as PackedScene
#@export var main_menu: PackedScene

func _ready():
	hide()
	level3_manager.connect("toggle_game_paused", _on_game_manager_toggle_game_paused)

func _process(delta):
	pass

func _on_game_manager_toggle_game_paused(is_paused : bool):
	if(is_paused):
		show()
	else:
		hide()


func _on_resume_button_pressed():
	level3_manager.game_paused = false


func _on_exit_button_pressed():
	level3_manager.game_paused = false
	#get_tree().change_scene_to_packed(main_menu)
	SceneSwitcher.switch_scene("res://scenes/UI/main menu/main_menu.tscn")

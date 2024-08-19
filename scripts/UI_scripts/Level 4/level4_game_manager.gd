extends Node

class_name Level4_GameManager

signal toggle_game_paused(is_paused: bool)


var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

func _input(event):
	if(event.is_action_pressed("ui_cancel")):
		game_paused = !game_paused

# Step to setup: 
#Level4_GameManager -> process -> mode = Always
#Level4 -> process -> mode = Pausable
#CanvasLayer -> Level4_PauseMenu -> process -> mode = When Paused
#CanvasLayer -> Level4_PauseMenu -> Level 4 Game Manager select Level4_GameManager

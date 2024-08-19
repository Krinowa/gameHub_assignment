extends Node

class_name Level2_GameManager

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
#Level2_GameManager -> process -> mode = Always
#Level2 -> process -> mode = Pausable
#CanvasLayer -> Level2_PauseMenu -> process -> mode = When Paused
#CanvasLayer -> Level2_PauseMenu -> Level  Game Manager select Level2_GameManager

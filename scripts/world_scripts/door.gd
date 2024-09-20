extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var door_open_audio = $door_open

var is_door_open = false

@onready var level3 = load("res://scenes/UI/level 3/level3_game_manager.tscn") as PackedScene

func _ready():
	animation_player.play("close")

func _on_area_2d_body_entered(body):
	SignalBus.connect("on_key_collected", on_signal_key_collected)

func on_signal_key_collected(node : Node, has_key : bool):
	if(has_key):
		animation_player.play("open")
		door_open_audio.play()
		is_door_open = true
	else:
		animation_player.play("close")
		is_door_open = false

func interaction():
	get_tree().change_scene_to_packed(level3)

func _input(event):
	if event.is_action_pressed("interact") and is_door_open:
		interaction()

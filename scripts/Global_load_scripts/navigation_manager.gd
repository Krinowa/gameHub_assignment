extends Node

var scene_level1 = load("res://scenes/Level1.tscn")
var scene_level2 = load("res://scenes/Level2.tscn")
var scene_level3 = load("res://scenes/Level3.tscn")

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		'level_1':
			scene_to_load = scene_level2
		'level_2':
			scene_to_load = scene_level3
		'level_3':
			scene_to_load = scene_level1

	if scene_to_load != null:
		
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)


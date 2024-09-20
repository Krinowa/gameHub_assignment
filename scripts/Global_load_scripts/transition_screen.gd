extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

var scene_level1 = load("res://scenes/Level1.tscn")
var scene_level2 = load("res://scenes/Level2.tscn")
var scene_level3 = load("res://scenes/Level3.tscn")

var spawn_door_tag

func _ready():
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		on_transition_finished.emit()
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color_rect.visible = false
	
func transition():
	color_rect.visible = true
	animation_player.play("fade_to_black")


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
		
		transition()
		await transition().on_transition_finished
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)


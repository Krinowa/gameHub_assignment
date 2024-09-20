extends Area2D

var entered = false


func _on_body_entered(body: CharacterBody2D):
	if body is CharacterBody2D:
		entered = true 
		print("Body entered: ", body)

func _process(_delta):
	if entered == true:
		if Input.is_action_just_pressed("ui_enter"):
			get_tree().change_scene_to_file("res://scenes/boss_room.tscn")

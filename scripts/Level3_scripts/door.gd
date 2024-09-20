extends Area2D

class_name Door

@export var destination_level_tag: String
@export var destination_door_tag: String #we can have many door in the same scene

@export var spawn_direction = "up" #spawn direction for current scene door

@onready var spawn = $Spawn

func _on_area_entered(area):
	if area.get_parent() is Player:
		print('yes')
		NavigationManager.go_to_level(destination_level_tag, destination_door_tag)

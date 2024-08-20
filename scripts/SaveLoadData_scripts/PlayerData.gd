extends Resource
class_name PlayerData

@export var speed = 200.0
@export var jump_velocity = -400.0

@export var health = 100

@export var savePosition : Vector2

func change_health(value: int):
	health += value

func update_position(value: Vector2):
	savePosition = value
   

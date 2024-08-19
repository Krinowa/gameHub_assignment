extends Node2D

class_name Level2

@onready var initial_camera_limiter = $CameraLimiters/camera_limiter_1
@onready var player: Player = $Player

#func _ready():
	#player.camera.camera_limit_manager.set_limiter(initial_camera_limiter, true)

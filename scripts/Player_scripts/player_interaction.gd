extends Area2D

@onready var player: Player = get_parent()

func _on_area_entered(area):
	if area is CameraLimiter:
		player.camera.camera_limit_manager.set_limiter(area)

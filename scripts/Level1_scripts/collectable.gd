extends Area2D
@onready var animated = $AnimatedSprite2D

func _on_body_entered(body):
	if body.name == "Player":
		animated.play("Collected")
		await animated.animation_finished
		queue_free()
		



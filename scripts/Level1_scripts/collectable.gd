extends Area2D
@onready var animated = $AnimatedSprite2D

func _ready():
	print(CollectableManager)  # Should output a reference to the singleton


func _on_body_entered(body):
	if body.name == "Player":
		animated.play("Collected")
		await animated.animation_finished
		CollectableManager.add_collected_item()
		queue_free()



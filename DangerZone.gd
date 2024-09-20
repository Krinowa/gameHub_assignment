extends Node2D


@export var speed = 200.0
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer

var current_speed = 0.0

func _physics_process(delta):
	position.y += current_speed * delta


func fall():
	current_speed = speed
	await get_tree().create_timer(3).timeout
	queue_free()

func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
	
	


func _on_hit_point_body_entered(body):
	if body.get_parent() is Player:
		Engine.time_scale = 0.5
		body.get_parent().handle_death()
		timer.start()


func _on_detection_body_entered(body):
	if body.get_parent() is Player:
		animation_player.play("shake")


func _on_timer_2_timeout():
	pass # Replace with function body.

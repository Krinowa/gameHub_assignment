extends Node2D

@export var speed = 200.0
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer

var current_speed = 0.0

func _physics_process(delta):
	position.y += current_speed * delta

func _on_hitbox_area_entered(area):
	if area.get_parent() is Player:
		Engine.time_scale = 0.5
		area.get_parent().handle_death()
		timer.start()

func _on_player_detect_area_entered(area):
	if area.get_parent() is Player:
		animation_player.play("shake")

func fall():
	current_speed = speed
	await get_tree().create_timer(3).timeout
	queue_free()

func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

extends CharacterBody2D

var Player = null
var attack_player = false

func _physics_process(delta):
	if attack_player:
		$AnimatedSprite2D.play("attack")

func _on_detection_area_body_entered(body):
	Player = body
	attack_player = true

func _on_detection_area_body_exited(body):
	Player = null
	attack_player = false



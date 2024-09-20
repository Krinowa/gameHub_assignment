extends Node2D

func _ready():
	$AnimationPlayer.play("MushroomUp")
	$AnimationPlayer.play("Frogidle")


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		$AnimationPlayer.stop("MushroomUp")
		$AnimationPlayer.stop("Frogidle")
		$AnimationPlayer.play("MushroomDown")
		$AnimationPlayer.play("Frog_dead")


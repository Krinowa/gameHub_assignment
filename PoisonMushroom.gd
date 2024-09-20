extends StaticBody2D

signal frog_swallow

var mushroomtaken = false
var in_frog_zone = false




func _on_area_2d_body_entered(body: CharacterBody2D):
	if mushroomtaken == false:
		mushroomtaken = true
		$Sprite.queue_free()

func _process(delta):
	if mushroomtaken == true:
		if in_frog_zone ==true:
			if Input.is_action_just_pressed("collect"):
				print("frog_swallow")
				emit_signal("frog_swallow")
 

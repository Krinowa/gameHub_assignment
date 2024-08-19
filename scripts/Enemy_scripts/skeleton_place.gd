extends Node2D





func _on_area_2d_body_entered(body):
	if body.has_method('change_state'):
		body.change_state()

extends StaticBody2D


func _on_spike_hit_body_entered(body):
	if body.is_in_group('player'):
		body.attack_detect()

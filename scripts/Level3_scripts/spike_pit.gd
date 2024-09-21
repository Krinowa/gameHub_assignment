extends StaticBody2D

func _on_spike_hit_area_entered(area):
	if area.get_parent() is Player:
		$Timer.start()
		area.get_parent().handle_death()
		
func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

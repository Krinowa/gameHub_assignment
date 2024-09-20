extends Area2D

func _on_body_entered(body):
	visible = false
	set_collision_mask_value(2, false)
	SignalBus.emit_signal("on_key_collected", get_parent(), true)
	$SoundKey.play()


func _on_sound_key_finished():
	queue_free()

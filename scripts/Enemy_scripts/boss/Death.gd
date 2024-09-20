extends BossState


func enter():
	super.enter()
	animation_player.play("death")
	await animation_player.animation_finished
	animation_player.play("boss_slained")
	# Wait for the "boss_slained" animation to finish
	await animation_player.animation_finished
	# Once the animation finishes, free the boss from the scene
	get_parent().get_parent().queue_free()

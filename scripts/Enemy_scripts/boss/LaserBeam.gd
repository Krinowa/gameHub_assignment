extends BossState

@onready var pivot = $"../../pivot"
var can_transition: bool = false
 
func enter():
	super.enter()
	await play_animation("laser_cast")
	await play_animation("laser")
	can_transition = true
 
func play_animation(anim_name):
	animation_player.play(anim_name)
	await animation_player.animation_finished
 
func set_target():
	pivot.rotation = (owner.direction - pivot.position).angle()
 
func transition():
	if can_transition:
		can_transition = false
		var chance = randi() % 2
		match chance:
			0:
				get_parent().change_state("Follow")
			1:
				get_parent().change_state("Dash")

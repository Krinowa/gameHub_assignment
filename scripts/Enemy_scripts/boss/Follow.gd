extends BossState

@onready var dash_timer =$"../../Timer"  # Reference to the Timer node

func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("idle")
	dash_timer.start(2.0)
 
func exit():
	super.exit()
	owner.set_physics_process(false)
	dash_timer.stop()

func transition():
	var distance = owner.direction.length()
	
	if distance < 30:
		get_parent().change_state("MeleeAttack")
	elif distance > 130:
		var chance = randi() % 4
		match chance:
			0:
				get_parent().change_state("HomingMissile")
			1:
				get_parent().change_state("LaserBeam")
			2:
				get_parent().change_state("FireBlast")
			3:
				get_parent().change_state("ElectricBall")
 
func _on_timer_timeout():
	print("timeup")
	get_parent().change_state("Dash")



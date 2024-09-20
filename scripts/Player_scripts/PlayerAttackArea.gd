extends Area2D

@export var damage : int = 10
@export var player : Player
@export var facing_shape_2d : FacingCollisionShape2D

func _ready():
	player.connect("facing_direction_changed", _on_player_facing_direction_changed)
	SignalBus.connect("on_attack_input", _on_attack_triggered)

func _on_attack_triggered():
	#Check for overlapping bodies inside the Area2D when attacking
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		for child in body.get_children():
			# Check if the child is damageable
			if child is Damageable:
				# Get the direction from the hit area to the body
				var direction_to_damageable = (body.global_position - get_parent().global_position)
				var direction_sign = sign(direction_to_damageable.x)
				print("attack")
				# Apply damage based on the attack direction
				if direction_sign > 0:
					child.hit(damage, Vector2.RIGHT)
				elif direction_sign < 0:
					child.hit(damage, Vector2.LEFT)
				else:
					child.hit(damage, Vector2.ZERO)

		# If entered enemy has a method attacked, pass the damage value to the enemy node
		# e.g: skeleton.gd
		if body.has_method("attacked"):
			body.attacked(damage)

func _on_player_facing_direction_changed(facing_right : bool):
	if(facing_right):
		facing_shape_2d.position = facing_shape_2d.facing_right_position
	else:
		facing_shape_2d.position = facing_shape_2d.facing_left_position


extends Area2D

@export var damage : int = 5
@export var golem : Golem
@export var facing_shape_2d : FacingCollisionShape2D

func _ready():
	#golem.connect("facing_direction_changed", _on_golem_facing_direction_changed)
	pass

func _on_body_entered(body):
	for child in body.get_children():
		if child is Damageable:
			# Get the direction from the hit area to the body
			var direction_to_damageable = (body.global_position - get_parent().global_position)
			var direction_sign = sign(direction_to_damageable.x)
			
			if(direction_sign > 0):
				child.hit(damage, Vector2.RIGHT)
			elif(direction_sign < 0):
				child.hit(damage, Vector2.LEFT)
			else:
				child.hit(damage, Vector2.ZERO)
	
	# If entered enemy has a method attacked, pass the damage value to the enemy node
	# e.g: skeleton.gd
	if body.has_method('attacked'):
		body.attacked(damage)



func _on_golem_facing_direction_changed(facing_right : bool):
	if(facing_right):
		facing_shape_2d.position = facing_shape_2d.facing_right_position
	else:
		facing_shape_2d.position = facing_shape_2d.facing_left_position


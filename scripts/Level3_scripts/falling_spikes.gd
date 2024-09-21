extends CharacterBody2D

@export var gravity: int = 1000
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var timer = $Timer

# Either stuck on ceiling or on ground
var is_stuck: bool = true

func _physics_process(delta):
	if not is_stuck:
		apply_gravity(delta)
		move_and_slide()

	# Handle raycast collisions
	if ray_cast.is_colliding():
		if ray_cast.collide_with_bodies:
			var collider = ray_cast.get_collider()
			if collider is Player:
				is_stuck = false
	# CharacterBody2D collisions
	if get_slide_collision_count() > 0:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider is TileMap:
				is_stuck = true
				#Turn off physics_process,
				# no point in running this once spike is ground
				set_physics_process(false)
			elif collider is Player:
				#death(collider)
				pass
				

func apply_gravity(delta):
	# Apply gravity to the velocity
	velocity.y += gravity * delta

#func death(collider):
	#Engine.time_scale = 0.5
	#collider.handle_death()
	#timer.start()
	

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		Engine.time_scale = 0.5
		area.get_parent().handle_death()
		timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

extends CharacterBody2D

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var golem_sprite_2d = $Sprite2D

@export var starting_move_direction : Vector2 = Vector2.LEFT
@export var movement_speed = 30.0
@export var hit_state : State

@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_chase = false
var player = null

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if player_chase and player != null:
		# Calculate direction towards the player
		var direction : Vector2 = (player.position - position).normalized()

		# Flip the sprite based on the direction
		if direction.x > 0:
			golem_sprite_2d.flip_h = false
		elif direction.x < 0:
			golem_sprite_2d.flip_h = true
		
		# Move towards the player if chasing and able to move
		if state_machine.check_if_can_move():
			velocity.x = direction.x * movement_speed
			# Update position to move towards the player
			position += direction * movement_speed * delta
	else:
		# Slow down when not chasing or in hit state
		if state_machine.current_state != hit_state:
			velocity.x = move_toward(velocity.x, 0, movement_speed)
	
	# Apply the calculated velocity
	move_and_slide()



func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player_chase = false

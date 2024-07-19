extends CharacterBody2D

class_name Player

@onready var jump_sfx = $SFX/JumpSFX as AudioStreamPlayer2D
@onready var attack_sfx = $SFX/AttackSFX as AudioStreamPlayer2D

@onready var animated_sprite_player = $AnimatedSprite2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isAttacking = false

signal facing_direction_changed(facing_right : bool)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sfx.play()
	
	if Input.is_action_just_released("jump") && velocity.y < 0:
		velocity.y = 0
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	
	#Flip the Sprite
	if direction > 0:
		animated_sprite_player.flip_h = false
		
	elif direction < 0:
		animated_sprite_player.flip_h = true
		
	emit_signal("facing_direction_changed", !animated_sprite_player.flip_h)
	
	# Play animations:
	if not isAttacking:
		if is_on_floor():
			if direction == 0:
				animated_sprite_player.play("idle")
			elif direction != 0:
				animated_sprite_player.play("run")
		else:
			if velocity.y < 0:
				animated_sprite_player.play("jump")
			else:
				animated_sprite_player.play("fall")

	# Handle attack
	if Input.is_action_just_pressed("attack") and not isAttacking:
		animated_sprite_player.play("attack")
		isAttacking = true
		$AttackArea/CollisionShape2D.disabled = false
		attack_sfx.play()

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_animated_sprite_2d_animation_looped():
	if animated_sprite_player.animation == "attack":
		$AttackArea/CollisionShape2D.disabled = true
		isAttacking = false

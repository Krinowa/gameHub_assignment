extends CharacterBody2D

class_name Player

@onready var camera = $Camera
@onready var jump_sfx = $SFX/JumpSFX as AudioStreamPlayer2D
@onready var attack_sfx = $SFX/AttackSFX as AudioStreamPlayer2D
@onready var dead_sfx = $SFX/DeadSFX as AudioStreamPlayer2D
@onready var dash_sfx = $SFX/DashSFX as AudioStreamPlayer2D

@onready var animated_sprite_player = $AnimatedSprite2D



const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 600.0
const DASH_TIME = 0.2
const DASH_ACCELERATION = 3000.0  # Acceleration towards dash speed
const DASH_DECELERATION = 3000.0  # Deceleration after dash ends
const DASH_COOLDOWN = 1.0  # Cooldown time in seconds
const WALL_JUMP_FORCE_X = 300.0  # Horizontal force applied when wall jumping
const WALL_SLIDE_SPEED = 50.0  # Speed of sliding down the wall
const MAX_HEALTH = 100  # Maximum health value

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isAttacking = false
var isDashing = false
var dash_time_left = 0.0
var dash_target_speed = 0.0
var dash_cooldown_timer = 0.0  # Tracks the cooldown time manually
var isOnWall = false
var is_wall_sliding = false
var jump_max = 2
var jump_count = 0
var is_dead = false 
var health = MAX_HEALTH


signal facing_direction_changed(facing_right : bool)
signal health_changed(current_health : int)

func _physics_process(delta):
	# Add gravity if not dashing and not on a wall
	if not is_on_floor() and not isDashing and not isOnWall:
		velocity.y += gravity * delta

	# Check for wall collision
	if is_on_wall() and Input.is_action_pressed("move_right") and Input.is_action_just_pressed("jump"):
		jump_count = 0
		velocity.y = JUMP_VELOCITY
		velocity.x = -WALL_JUMP_FORCE_X
	
	if is_on_wall() and Input.is_action_pressed("move_left") and Input.is_action_just_pressed("jump"):
		jump_count = 0
		velocity.y = JUMP_VELOCITY
		velocity.x = WALL_JUMP_FORCE_X

	# Handle dash input
	if Input.is_action_just_pressed("dash") and not isDashing and dash_cooldown_timer <= 0 and not isAttacking:
		start_dash()

	if isDashing:
		dash_time_left -= delta
		if dash_time_left <= 0:
			end_dash()

	# Handle jump if not wall jumping
	if is_on_floor() and jump_count != 0:
		jump_count = 0
	
	if jump_count < jump_max:
		if Input.is_action_just_pressed("jump") and not isDashing and not isOnWall:
			velocity.y = JUMP_VELOCITY
			jump_count += 1
			jump_sfx.play()
	
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y = 0
	
	# Get input direction and handle movement/deceleration
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if direction > 0:
		animated_sprite_player.flip_h = false
	elif direction < 0:
		animated_sprite_player.flip_h = true
		
	emit_signal("facing_direction_changed", !animated_sprite_player.flip_h)
	
	# Play animations
	if not isAttacking and not isDashing:
		if is_on_floor():
			if direction == 0:
				animated_sprite_player.play("idle")
			elif direction != 0:
				animated_sprite_player.play("run")
		elif isOnWall:
			animated_sprite_player.play("wall_slide")
		else:
			if velocity.y < 0:
				if jump_count == 1:
					animated_sprite_player.play("jump")
				elif jump_count == 2:
					animated_sprite_player.play("double_jump")
			else:
				animated_sprite_player.play("fall")

	# Handle attack
	if Input.is_action_just_pressed("attack") and not isAttacking and not isDashing and not is_on_wall():
		animated_sprite_player.play("attack")
		isAttacking = true
		$AttackArea/CollisionShape2D.disabled = false
		attack_sfx.play()

	# Handle movement with smoother dash
	if isDashing and not isAttacking:
		velocity.x = move_toward(velocity.x, dash_target_speed, DASH_ACCELERATION * delta)
	else:
		if direction:
			velocity.x = move_toward(velocity.x, direction * SPEED, DASH_DECELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, DASH_DECELERATION * delta)

	move_and_slide()
	wall_slide(delta)

	# Update the cooldown timer
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	else:
		dash_cooldown_timer = 0

func start_dash():
	isDashing = true
	dash_time_left = DASH_TIME
	dash_target_speed = DASH_SPEED * (1 if not animated_sprite_player.flip_h else -1)
	dash_sfx.play()
	animated_sprite_player.play("dash")
	dash_cooldown_timer = DASH_COOLDOWN

func end_dash():
	isDashing = false
	dash_target_speed = 0.0
	# Ensure the correct animation plays after dashing
	if is_on_floor():
		if Input.get_axis("move_left", "move_right") != 0:
			animated_sprite_player.play("run")
		else:
			animated_sprite_player.play("idle")
	else:
		animated_sprite_player.play("fall")

func wall_slide(delta):
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			is_wall_sliding = true
		else: 
			is_wall_sliding = false
	else:
		is_wall_sliding = false
		
	if is_wall_sliding:
		velocity.y += (WALL_SLIDE_SPEED * delta)
		velocity.y = min(velocity.y, WALL_SLIDE_SPEED)
		animated_sprite_player.play("wall_slide")
		
func handle_death():
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	animated_sprite_player.play("dead")
	dead_sfx.play()
	set_physics_process(false)

func take_damage(amount):
	health -= amount
	emit_signal("health_changed", health)
	if health <= 0:
		handle_death()

# Animation looped callback
func _on_animated_sprite_2d_animation_looped():
	if animated_sprite_player.animation == "attack":
		$AttackArea/CollisionShape2D.disabled = true
		isAttacking = false



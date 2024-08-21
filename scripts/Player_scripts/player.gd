extends CharacterBody2D

class_name Player

#signal update_ui 

@onready var camera = $Camera
@onready var jump_sfx = $SFX/JumpSFX as AudioStreamPlayer2D
@onready var attack_sfx = $SFX/AttackSFX as AudioStreamPlayer2D
@onready var dead_sfx = $SFX/DeadSFX as AudioStreamPlayer2D
@onready var dash_sfx = $SFX/DashSFX as AudioStreamPlayer2D

@onready var animated_sprite_player = $AnimatedSprite2D

# changed
var save_file_path = "user://save/"
var save_file_name = "PlayerSave.tres"

# Access everything from the PlayerData with default value if it is not loaded
var playerData = PlayerData.new()

# Access the speed and jump_velocity variable from PlayerData
# Variables doest need anymore since we retrieve from PlayerData

# var health = 100 
# const SPEED = 200.0
# const JUMP_VELOCITY = -400.0
const DASH_SPEED = 600.0
const DASH_TIME = 0.2
const DASH_ACCELERATION = 3000.0  # Acceleration towards dash speed
const DASH_DECELERATION = 3000.0  # Deceleration after dash ends
const DASH_COOLDOWN = 1.0  # Cooldown time in seconds
const WALL_JUMP_FORCE_X = 300.0  # Horizontal force applied when wall jumping
const WALL_SLIDE_SPEED = 50.0  # Speed of sliding down the wall
const MAX_HEALTH = 100
# changed  

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

# changed
func _ready():
	# Access the save path where we going to store our data
	verify_save_directory(save_file_path)

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func load_data():
	# Load the file from the path to replace the default value of variable playerData
	playerData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	on_start_load_position()
	print("loaded")

# On the moment we load the game, call this function to set the save position to current position
# We save the position every single frame, but only retrieve the save position when load the game
func on_start_load_position():
	self.position = playerData.savePosition

func save():
	# Save the current value of variable playerData(latest Data) to the path specify to save
	ResourceSaver.save(playerData, save_file_path + save_file_name)
	print("saved")

func _process(delta):
	if Input.is_action_just_pressed("Save"):
		save()
	if Input.is_action_just_pressed("Load"):
		load_data()
	# To configure input action: project -> Project Settings -> Input Map
	# L -> Load , K -> Save

	# emit the signal to the node where want to display health progress like health bar
	# self.position not necessarily need to update to the ui but need to be save
	# currently only getting the ui position and update to the ui without saving the position
	emit_signal("update_ui", playerData.health, self.position)
	
	# We save the position every single frame, but only retrieve the save position when load the game
	playerData.update_position(self.position)
# changed

func _physics_process(delta):
	# Add gravity if not dashing and not on a wall
	if not is_on_floor() and not isDashing and not isOnWall:
		velocity.y += gravity * delta

	# Check for wall collision
	if is_on_wall() and Input.is_action_pressed("move_right") and Input.is_action_just_pressed("jump"):
		jump_count = 0
		# changed
		velocity.y = playerData.jump_velocity
		velocity.x = -WALL_JUMP_FORCE_X
	
	if is_on_wall() and Input.is_action_pressed("move_left") and Input.is_action_just_pressed("jump"):
		jump_count = 0
		velocity.y = playerData.jump_velocity
		velocity.x = WALL_JUMP_FORCE_X

	# Handle dash input
	if Input.is_action_just_pressed("dash") and not isDashing and dash_cooldown_timer <= 0:
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
			velocity.y = playerData.jump_velocity
			jump_count += 1
			jump_sfx.play()
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y = 0
	
	# Get input direction and handle movement/deceleration
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
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
	if Input.is_action_just_pressed("attack") and not isAttacking and not isDashing:
		animated_sprite_player.play("attack")
		isAttacking = true
		$AttackArea/CollisionShape2D.disabled = false
		attack_sfx.play()

	# Handle movement with smoother dash
	if isDashing and not isAttacking:
		velocity.x = move_toward(velocity.x, dash_target_speed, DASH_ACCELERATION * delta)
	else:
		if direction:
			velocity.x = move_toward(velocity.x, direction * playerData.speed, DASH_DECELERATION * delta)
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

#changed on add comment only -> # When press attack, the attack area change to true to hit the enemy
# Animation looped callback
func _on_animated_sprite_2d_animation_looped():
	if animated_sprite_player.animation == "attack":
		$AttackArea/CollisionShape2D.disabled = true
		isAttacking = false

# changed
# Detect the hit by skeleton enemy and deduct the health level
func attack_detect():
	print('hit')

# Change the health value directly in the playerData file everytime change of health value of player
# Because we are retrieving the health value from the playerData file
# The playerData file can save directly
#use take_datam
#func take_damage():
	#playerData.change_health(-5)

func gain_health():
	playerData.change_health(5)

func _on_control_change_health(action):
	if action == "+":
		gain_health()
	elif action == "-":
		#take_damage()
		pass
# changed

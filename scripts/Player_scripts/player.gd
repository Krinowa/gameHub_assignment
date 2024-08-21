extends CharacterBody2D

class_name Player

#signal update_ui 

@onready var jump_sfx = $SFX/JumpSFX as AudioStreamPlayer2D
@onready var attack_sfx = $SFX/AttackSFX as AudioStreamPlayer2D

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


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isAttacking = false

signal facing_direction_changed(facing_right : bool)

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
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		# changed
		velocity.y = playerData.jump_velocity
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
		#changed on speed
		velocity.x = direction * playerData.speed
	else:
		#changed on speed
		velocity.x = move_toward(velocity.x, 0, playerData.speed)
	
	move_and_slide()


#changed on add comment only -> # When press attack, the attack area change to true to hit the enemy
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
func take_damage():
	playerData.change_health(-5)

func gain_health():
	playerData.change_health(5)

func _on_control_change_health(action):
	if action == "+":
		gain_health()
	elif action == "-":
		take_damage()
# changed

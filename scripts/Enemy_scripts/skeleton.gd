extends CharacterBody2D

var gravity = 15
var speed = 100 # Horizontal movement speed
var direction = 1 # 1 for right, -1 for left
var turned_side
var health = 100
@onready var state_machine = $AnimationTree.get('parameters/playback')

@onready var animated_sprite = $Sprite2D # Adjust the path to your sprite node

func _ready():
	state_machine.travel('walk')
	move_char()
	$TextureProgressBar.visible = false

func _physics_process(delta):
	# Apply gravity
	#velocity.y += gravity * delta

	# Move horizontally
	velocity.x = speed * direction

	# Move the character
	move_and_slide()

func move_char():
	$AnimationPlayer.play("walk")
	#velocity.x = -speed

#if detected player body enter the skeleton detected area, perform attack action
func _on_detect_player_area_entered(area):
	if area.get_parent() is Player:
		velocity.x = 0
		$AnimationPlayer.play("attack")

#if detected player body exit the skeleton detected area, perform walk action
func _on_detect_player_area_exited(area):
	if area.get_parent() is Player and health > 0:
		$AnimationPlayer.play("walk")

# For skeleton place area function
# Change the direction of skeleton if skeleton hit the collision
func change_state():
	direction *= -1  # change the velocity 
	# instead of just flipping animated sprite, we need to flip collision box too
	#if direction < 0:
		#animated_sprite.flip_h
	scale.x *= -1  # use scale.x able to change sprite and collision box direction together

# when the player enter the attack to player collision, call the attack_detect function in player node
#func _on_attack_to_player_body_entered(body):
	#if body.is_in_group('player'):
		#body.attack_detect()

func _on_attack_to_player_area_entered(area):
	var player = area.get_parent()  # Assuming the player is the parent of the area
	if player.is_in_group('player'):
		player.attack_detect()


# when detect player at the back, change the direction
#func _on_player_is_back_body_entered(body):
	#if body.is_in_group('player'):
		#change_state()
func _on_player_is_back_area_entered(area):
	if area.get_parent() is Player:
		change_state()


func attacked(damage):
	$TextureProgressBar.visible = true
	health -= damage
	print(health)
	$TextureProgressBar.value = health
	$Timer.wait_time = 1
	$Timer.start()
	if health <= 0:
		velocity.x = 0
		$AnimationPlayer.play('die')
		$TextureProgressBar.visible = false

func _on_timer_timeout():
	$TextureProgressBar.visible = false













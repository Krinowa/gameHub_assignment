extends CharacterBody2D

var speed = 25 
var player_chase = false
var player = null

var health = 100

@onready var healthbar = $Healthbar  # Ensure the Healthbar node is a ProgressBar or similar

func _ready():
	# Initialize the health bar
	if healthbar and healthbar is ProgressBar:
		healthbar.value = health
		healthbar.max_value = 100  # Set the maximum value for the health bar
		healthbar.visible = true
	else:
		print("Healthbar node is not a ProgressBar or is missing.")

func _physics_process(delta):
	if player_chase and player != null:
		var direction = (player.position - position).normalized()
		position += direction * speed * delta
		
		$AnimatedSprite2D.play("Attack")
		
		# Flip sprite based on player position
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("Flying")

func _on_detection_area_body_entered(body: PhysicsBody2D):
	if body.is_in_group("Player"):  # Make sure it’s the player
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: PhysicsBody2D):
	if body == player:
		player = null
		player_chase = false
	
func update_health(amount):
	if healthbar and healthbar is ProgressBar:
		# Decrease health and update health bar
		health -= amount
		health = max(health, 0)  # Ensure health does not go below 0
		healthbar.value = health
	
		# Handle visibility of health bar
		if health <= 0:
			healthbar.visible = false
			queue_free()  # Remove the enemy from the scene
	else:
		print("Healthbar node is not a ProgressBar or is missing.")



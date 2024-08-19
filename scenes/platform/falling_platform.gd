extends CharacterBody2D

var is_fall
var original_position

func _ready():
	original_position = position  # Store the original position of the platform
	$Timer.connect("timeout", Callable(self, "_on_timer_timeout"))  # Connect the timeout signal

func _physics_process(delta):
	if is_fall == false:
		velocity.y  += 50
	move_and_slide()

# Once detect player jump onto the platform, play the shake animation and call fall function
func _on_player_entered_body_entered(body):
	if body.is_in_group('player'):
		$AnimationPlayer.play('shake')

# This function fall is call from AnimationPlayer
# After falling, waiting for 5 seconds
func fall():
	is_fall = false
	$Timer.wait_time = 5
	$Timer.start()

# Once 5s timeout, position the platform back to original place
func _on_timer_timeout():
	velocity = Vector2.ZERO # Reset velocity to zero
	position = original_position  # Move platform back to original position
	is_fall = true  # Reset the falling state to true so it not to fall again

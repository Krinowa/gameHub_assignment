extends StaticBody2D

class_name GroundButton

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var unpressed_collision: CollisionPolygon2D = $UnpressedCollision
@onready var pressed_collision: CollisionPolygon2D = $PressedCollision

var is_button_pressed: bool = false

func press_button():
	is_button_pressed = true
	# When the button is pressed, the unpressed collision should be disabled, pressed button should enable
	unpressed_collision.set_deferred("disabled", true)
	pressed_collision.set_deferred("disabled", false)
	animated_sprite.play('pressed')
	open_stone_gate()

func unpress_button():
	is_button_pressed = false
	# When the button is unpressed, the pressed collision should be disabled, unpressed button should enable
	unpressed_collision.set_deferred("disabled", false)
	pressed_collision.set_deferred("disabled", true)
	animated_sprite.play('unpressed')
	close_stone_gate()

func close_stone_gate():
	get_node("StoneGate").close_stone_gate()

func open_stone_gate():
	get_node("StoneGate").open_stone_gate()

# if the body entered the pressedDetector and the button is NOT pressed, then pressed the button
func _on_pressed_detector_body_entered(body):
	if body.is_in_group('rigidBox'):
		print('rigidbox')
	elif body.is_in_group('player'):
		print('player')
	if body.is_in_group('rigidBox') or body.is_in_group('player'):
		if is_button_pressed == false:
			press_button()

#func _on_player_is_back_area_entered(area):
	#if area.get_parent() is Player:
		#change_state()

# if the body exited the pressedDetector and the button is pressed, then unpressed the button
func _on_pressed_detector_body_exited(body):
	if body.is_in_group('rigidBox') or body.is_in_group('player'):
		if is_button_pressed == true:
			unpress_button()

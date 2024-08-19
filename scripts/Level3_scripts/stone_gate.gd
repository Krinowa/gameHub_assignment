extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var state
var is_closed: bool = true
var state_queue = []
#c=closed, o=opened, c,o,c,o,c,o (only check the last state whether is open or close

enum states {
	IDLE,
	CLOSE,
	OPEN
}

func ready():
	state = states.IDLE

func _process(delta):
	match state:
		states.IDLE:
			animated_sprite.play("idle")
		states.CLOSE:
			#Idle state is technically closed, you dont want to close when it is IDLE
			if not is_closed:
				collision_shape.disabled = false
				animated_sprite.play("close")
				# wait to gate to finished animatiion, dont want it change the animation immediately
				await animated_sprite.animation_finished
				is_closed = true
		states.OPEN:
			if is_closed:
				collision_shape.disabled = true
				animated_sprite.play("open")
				# wait to gate to finished animatiion, dont want it change the animation immediately
				await animated_sprite.animation_finished
				is_closed = false
	# if the player do not hit the switch/ground button , there is not state to change
	# when the player hit the switch/ground button, it will add the state to this queue
	if state_queue.size() > 0:
		# Next state is the last element/state in array
		var next_state = state_queue.back() # Check the last element in array
		# Nothing to do if current state equal to next state
		if state == next_state: 
			return
		# If next state is close and currently is in IDLE state, do nothing
		if next_state ==states.CLOSE:
			#Nothing to do cause idle state is technically also close state
			if state == states.IDLE:
				state_queue.clear()
				return
			# If you are open, go to close state
			if state == states.OPEN:
				state = states.CLOSE
				state_queue.clear()
				return
		# If next state is Open and in IDLE or CLOSE, then go to open state
		if next_state == states.OPEN:
			state = states.OPEN
			state_queue.clear()

# if switch call close_state_gate, append the state into state_queue
func close_stone_gate():
	state_queue.append(states.CLOSE)

func open_stone_gate():
	state_queue.append(states.OPEN)


#Once the animation finished, check if is in closed state, if yes, change to IDLE state
func _on_animated_sprite_2d_animation_finished():
	if state == states.CLOSE:
		state = states.IDLE

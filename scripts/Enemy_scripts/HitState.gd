extends State

class_name HitState

@export var damageable : Damageable
@export var dead_state : State
@export var idle_state : State
@export var dead_animation_node : String = "dead"
@export var hit_aniamtion_node : String = "hit"
@export var knockback_speed : float = 130.0
@export var return_state : State
@onready var golem = $"../.."

@export var key_scene: PackedScene

@onready var timer : Timer = $Timer

func _ready():
	damageable.connect("on_hit", on_damageable_hit)
	print(golem.position)
	
func on_enter():
	timer.start()

func on_damageable_hit(node : Node, damage_amount : int, knockback_direction : Vector2):
	if(damageable.health > 0):
		character.velocity = knockback_speed * knockback_direction
		emit_signal("interrupt_state", self)
		playback.travel(hit_aniamtion_node)

	else:
		emit_signal("interrupt_state", dead_state)
		call_deferred("drop_key")
		playback.travel(dead_animation_node)

func on_exit():
	character.velocity = Vector2.ZERO

func _on_timer_timeout():
	next_state = return_state
	
func drop_key():
	var key_instance = key_scene.instantiate()  # Create an instance of the key scene
	key_instance.position = golem.position      # Set the key's position to the enemy's current position

	# Print position for debugging
	print("Dropping key at position: ", key_instance.position)

	# Add the key directly to the current scene (the root node)
	get_tree().current_scene.call_deferred("add_child", key_instance)
	
	# Check if the key was successfully added
	if key_instance in get_tree().current_scene.get_children():
		print("Key successfully added to scene")
	else:
		print("Failed to add key to scene")

extends CharacterBody2D

@onready var boss_sprite = $Sprite2d
@export var speed = 60
var player_chase = false
@onready var player = get_parent().find_child("Player")
@onready var sprite = $Sprite2d
#@export var starting_move_direction : Vector2 = Vector2.LEFT
var direction : Vector2
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var state
var finite_state_machine


func _ready():
	finite_state_machine = FiniteStateMachine.new()
	walk()

func change_state(new_state_name):
	if state != null:
		state.queue_free()
	state = finite_state_machine.get_state(new_state_name).new()
	state.setup("change_state", $AnimationPlayer, self)
	state.name = "current_state"
	add_child(state)

func idle():
	change_state("idle")
	state.idle()

func attack():
	change_state("attack")
	state.attack()

func walk():
	change_state("walk")
	state.walk()

func _process(delta):
	direction = (player.position - position)
	
	if direction.x > 0:
		scale.x = -scale.x
	elif direction.x < 0:
		scale.x = scale.x

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Normalize direction and set x velocity
	if direction.length() > 0:
		velocity.x = direction.normalized().x * speed
	else:
		velocity.x = 0  # Stop moving if direction length is zero
	move_and_slide()
#func _on_detection_area_body_entered(body):
	#player = body
	#player_chase = false
#
#func _on_detection_area_body_exited(body):
	#body = null
	#player_chase = false
#
func hit():
	$AttackDetector.monitoring = true
	
func end_of_hit():
	$AttackDetector.monitoring = false
	
func start_walking():
	walk()


func _on_player_detector_body_entered(body):
	attack()

func _on_attack_detector_body_entered(body):
	get_tree().reload_current_scene()


#func _on_player_detector_body_entered(body):
	#attack()

#
#func _on_attack_detector_body_entered(body):
	#attack()
#
#
#func _on_attack_detector_body_exited(body):
	#idle() # Replace with function body.

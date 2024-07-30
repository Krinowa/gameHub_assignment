extends CharacterBody2D

@onready var boss_sprite = $Sprite2d
@export var speed = 20
var player_chase = false
var player = null
@export var starting_move_direction : Vector2 = Vector2.LEFT
var direction : Vector2 = starting_move_direction


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func move_char():

	$AnimationPlayer.play("walk")
	velocity.x = -speed
	
	
func _physics_process(delta):
	
	move_char()
	
	if not is_on_floor():
		velocity.y += gravity * delta

	#if player_chase:
		#position.x += (player.position.x - position.x) / speed
		##print(direction)
		
	if $AnimationPlayer.current_animation == "attack":
		return
		
	move_and_slide()
	
func _on_detection_area_body_entered(body):
	player = body
	player_chase = false

func _on_detection_area_body_exited(body):
	body = null
	player_chase = false

func hit():
	$AttackDetector.monitoring = true
	
func end_of_hit():
	$AttackDetector.monitoring = false
	
func start_walking():
	$AnimationPlayer.play("walk")


func _on_player_detector_body_entered(body):
	$AnimationPlayer.play("attack")
	


func _on_attack_detector_body_entered(body):
	get_tree().reload_current_scene()

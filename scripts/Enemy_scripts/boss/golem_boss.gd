extends CharacterBody2D
 
@onready var player = get_parent().find_child("Player")
@onready var sprite = $Sprite2D
@onready var progress_bar = $UI/ProgressBar
@export var character : CharacterBody2D
@onready var damageable = $Damageable



var direction : Vector2
var DEF = 0
 


func on_damageable_hit(node : Node, damage_amount : int, knockback_direction : Vector2):
	progress_bar.value = (damageable.health / 250) * 100
	if damageable.health <= 0:
		progress_bar.visible = false
		find_child("FiniteStateMachine").change_state("Death")


func _ready():
	set_physics_process(false)
	damageable.connect("on_hit", _on_damageable_on_hit)

func _process(_delta):
	direction = player.position - position
 
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
 
func _physics_process(delta):
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)
 
func take_damage():
	health2 -= 10 - DEF
 

func _on_damageable_on_hit(node, damage_taken, knockback_direction):
	if(damageable.health > 0):
		character.velocity = knockback_speed * knockback_direction

	else:
		#play death animation
		get_parent().change_state("death")

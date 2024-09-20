extends CharacterBody2D
 
@onready var player = get_parent().find_child("Player")
@onready var sprite = $Sprite2D
@onready var progress_bar = $UI/ProgressBar
@export var character : CharacterBody2D
@onready var damageable = $Damageable



var direction : Vector2
var DEF = 0
 
func _ready():
	damageable.connect("on_hit", on_damageable_hit)

func on_damageable_hit(node : Node, damage_amount : int, knockback_direction : Vector2):
	# Update the progress bar based on damageable health
	progress_bar.value = (damageable.health / 250) * 100

	if damageable.health <= 0:
		# Handle the boss death state
		progress_bar.visible = false
		find_child("FiniteStateMachine").change_state("Death")
		get_parent().queue_free()
 
func _process(_delta):
	direction = player.position - position
 

extends Node2D

@export var dialog_lines_not_enough: Array[String] = ["You need to collect more magical herb.", "Keep trying!"]
@export var dialog_lines_sufficient: Array[String] = ["Great job! You've collected enough herb.", "Here is your reward!"]
@onready var dialog_manager = DialogManager
@onready var player = get_parent().find_child("Player")
@onready var label = $Label
@onready var target_scene = preload("res://scenes/Level2.tscn")

var collectible_count = 0  # Counter for collected items
var player_near = false  # Tracks whether the player is near the NPC

func _ready():
	pass

# Check for interaction input when the player is near
func _process(delta):
	if player_near and Input.is_action_just_pressed("interact"):  # "interact" would be "E" key
		# Position the dialog box relative to the NPC (e.g., above the NPC)
		var dialog_position = global_position + Vector2(0, -20)  # Adjust the offset as needed
		# Fetch the collected items count from CollectableManager
		var collected_items = CollectableManager.total_collected_items
		
		# Set the dialog lines based on the collected items count
		if collected_items >= 2:
			dialog_manager.start_dialog(global_position + Vector2(0, -20), dialog_lines_sufficient)
			get_tree().change_scene_to_file("res://scenes/Level2.tscn")
		else:
			dialog_manager.start_dialog(global_position + Vector2(0, -20), dialog_lines_not_enough)

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		player_near = true
		print("Player entered")
		label.visible = true


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		player_near = false
		label.visible = false
		# Ensure the dialog is closed if the player leaves
		if dialog_manager.is_dialog_active:
			dialog_manager.close_dialog()
		print("Player exited")


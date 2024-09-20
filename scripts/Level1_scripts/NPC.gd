extends Node2D

@export var dialog_lines: Array[String] = ["Hello, traveler!", "Welcome to our village."]
@onready var dialog_manager = DialogManager
@onready var player = get_parent().find_child("Player")
@onready var label = $Label

var player_near = false  # Tracks whether the player is near the NPC


func _ready():
	pass

# Check for interaction input when the player is near
func _process(delta):
	if player_near and Input.is_action_just_pressed("interact"):  # "interact" would be "E" key
		# Position the dialog box relative to the NPC (e.g., above the NPC)
		var dialog_position = global_position + Vector2(0, -20)  # Adjust the offset as needed
		dialog_manager.start_dialog(dialog_position, dialog_lines)

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

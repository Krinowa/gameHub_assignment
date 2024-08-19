extends Area2D

class_name Switch

@onready var animated_sprite = $AnimatedSprite2D

var is_switch_open = false

func _on_Switch_area_entered(area):
	if area.name == 'AttackArea': 
		if not is_switch_open:
			right_switch_open()
		else:
			left_switch_close()

func left_switch_close():
	is_switch_open = false
	animated_sprite.play("close")
	close_stone_gate()

func right_switch_open():
	is_switch_open = true
	animated_sprite.play("open")
	open_stone_gate()

func close_stone_gate():
	get_node("StoneGate2").close_stone_gate()

func open_stone_gate():
	get_node("StoneGate2").open_stone_gate()

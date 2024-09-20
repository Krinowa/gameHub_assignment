extends Button
 
var dialogue : Dialogue:
	set(value):
		dialogue = value
		text = dialogue.path_option
		pass

func _on_pressed():
	if dialogue.options.size() == 0:
		DialogueManager.hide_dialogue()
		return

	DialogueManager.dialogue = dialogue

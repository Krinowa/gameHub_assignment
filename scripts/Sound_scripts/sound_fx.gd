extends Node

# This node is to fix the button sound effect disappear from one screen to another
func button_click():
	$"ButtonClick".play()
func button_hover():
	$"ButtonHover".play()

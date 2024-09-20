class_name OptionsMenu
extends Control

@onready var exit_button = $MarginContainer/VBoxContainer/Exit_Button as Button
@onready var setting_tab_container = $MarginContainer/VBoxContainer/Setting_tab_container as SettingsTabContainer


signal exit_options_menu

# Called when the node is added to the scene. It initializes the signals and sets the process to false.
func _ready():
	exit_button.button_down.connect(on_exit_pressed)
	#everytime press escape button it will find the on_exit_pressed function to exit to main page
	setting_tab_container.Exit_Options_menu.connect(on_exit_pressed) 
	set_process(false) #disable the options menu
	
# Emits the exit_options_menu signal and sets the process to false when the exit button is pressed.
func on_exit_pressed() -> void:
	exit_options_menu.emit()
	SettingsSignalBus.emit_set_settings_dictionary(SettingsContainer.create_storage_dictionary())
	set_process(false)
	SoundFx.button_click()

func _on_exit_button_mouse_entered():
	SoundFx.button_hover()

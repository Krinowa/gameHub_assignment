extends Control

@onready var option_button = $HBoxContainer/OptionButton as OptionButton

const RESOLUTION_DICTIONARY : Dictionary = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080" : Vector2i(1920, 1080)
}

func _ready():
	# Connect the OptionButton's item_selected signal to the on_resolution_selected function
	option_button.item_selected.connect(on_resolution_selected)
	# Add resolution options to the OptionButton
	add_resolution_items()
	# Load the current resolution data
	load_data()

# Load the current resolution data and select the appropriate item in the OptionButton
func load_data() -> void:
	# Get the resolution index from SettingsContainer and apply it
	on_resolution_selected(SettingsContainer.get_resolution_index())
	# Select the corresponding item in the OptionButton
	option_button.select(SettingsContainer.get_resolution_index())

# Add resolution items from the dictionary to the OptionButton
func add_resolution_items() -> void:
	for resolution_size_text in RESOLUTION_DICTIONARY:
		option_button.add_item(resolution_size_text)

# Handle the selection of a resolution from the OptionButton
func on_resolution_selected(index: int) -> void:
	# Emit a signal to notify other parts of the system about the resolution change
	SettingsSignalBus.emit_on_resolution_selected(index)
	# Set the window size to the selected resolution
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])

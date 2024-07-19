extends Node

const SETTINGS_SAVE_PATH: String = "user://SettingsData.save"

var settings_data_dict: Dictionary = {}

func _ready():
	SettingsSignalBus.set_settings_dictionary.connect(on_settings_save)
	load_settings_data()

# This is the functionality to save the game 
func on_settings_save(data: Dictionary) -> void:
	var save_settings_data_file = FileAccess.open_encrypted_with_pass(SETTINGS_SAVE_PATH, FileAccess.WRITE, "CoffeeCrow")
	var json_data_string = JSON.stringify(data)
	save_settings_data_file.store_line(json_data_string)

# project-> open user data folder -> find SettingsData.save ( the data is encrypted now)
# CoffeeCrow is the password
# If do not want encrypted, just use FileAccess.open and remove the password

# Function to loading game
func load_settings_data() -> void:
	if not FileAccess.file_exists(SETTINGS_SAVE_PATH):
		return

	var save_settings_data_file = FileAccess.open_encrypted_with_pass(SETTINGS_SAVE_PATH, FileAccess.READ, "CoffeeCrow")
	var loaded_data: Dictionary = {}
	
	while save_settings_data_file.get_position() < save_settings_data_file.get_length():
		var json_string = save_settings_data_file.get_line()
		var json = JSON.new()
		var _parsed_result = json.parse(json_string)
		
		loaded_data = json.get_data()
		#print(loaded_data)
	SettingsSignalBus.emit_load_settings_data(loaded_data)

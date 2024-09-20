extends Node
# SettingsDataContainer act as an centralised storage of all of the settings that we need to save it
# Other need the same settings can just pull out from here 

@onready var DEFAULT_SETTINGS : DefaultSettingsResource = preload("res://scenes/resources/settings/DefaultSettings.tres")
@onready var keybind_resource : PlayerKeybindResource = preload("res://scenes/resources/settings/PlayerKeybindDefault.tres")


var window_mode_index : int = 0
var resolution_index : int = 0
var master_volume : float = 0.0
var music_volume : float = 0.0
var sfx_volume : float = 0.0
var subtitles_set: bool = false

var loaded_data: Dictionary = {}

func _ready():
	handle_signals()
	create_storage_dictionary()

func create_storage_dictionary() -> Dictionary:
	var settings_container_dict: Dictionary = {
		"window_mode_index" : window_mode_index,
		"resolution_index" : resolution_index,
		"master_volume" : master_volume,
		"music_volume" : music_volume,
		"sfx_volume" : sfx_volume,
		"subtitles_set" : subtitles_set,
		"keybinds" : create_keybinds_dictionary()
	}
	
	#print(settings_container_dict)
	return settings_container_dict

func create_keybinds_dictionary() -> Dictionary:
	var keybinds_container_dict = {
		keybind_resource.MOVE_LEFT : keybind_resource.move_left_key,
		keybind_resource.MOVE_RIGHT : keybind_resource.move_right_key,
		keybind_resource.JUMP : keybind_resource.jump_key,
	}
	
	return keybinds_container_dict


func get_window_mode_index() -> int:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_WINDOW_MODE_INDEX
	return window_mode_index

func get_resolution_index() -> int:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_RESOLUTION_INDEX
	return resolution_index

func get_subtitles_set() -> bool:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_SUBTITLES_SET
	return subtitles_set

func get_master_volume() -> float:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_MASTER_VOLUME
	return master_volume

func get_music_volume() -> float:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_MUSIC_VOLUME
	return music_volume

func get_sfx_volume() -> float:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_SFX_VOLUME
	return sfx_volume

func get_keybind(action: String):
	if !loaded_data.has("keybinds"):
		match action:
			keybind_resource.MOVE_LEFT:
				return keybind_resource.DEFAULT_MOVE_LEFT_KEY
			keybind_resource.MOVE_RIGHT:
				return keybind_resource.DEFAULT_MOVE_RIGHT_KEY
			keybind_resource.JUMP:
				return keybind_resource.DEFAULT_JUMP_KEY
	else:
		match action:
			keybind_resource.MOVE_LEFT:
				return keybind_resource.move_left_key
			keybind_resource.MOVE_RIGHT:
				return keybind_resource.move_right_key
			keybind_resource.JUMP:
				return keybind_resource.jump_key

func on_window_mode_selected(index: int ) -> void:
	window_mode_index = index

func on_resolution_selected(index: int ) -> void:
	resolution_index = index

func on_subtitles_set(toggled: bool) -> void:
	subtitles_set = toggled

func on_master_sound_set(value: float) -> void:
	master_volume = value

func on_music_sound_set(value: float) -> void:
	music_volume = value

func on_sfx_sound_set(value: float) -> void:
	sfx_volume = value

func set_keybind(action: String, event) -> void:
	match action:
		keybind_resource.MOVE_LEFT:
			keybind_resource.move_left_key = event
		keybind_resource.MOVE_RIGHT:
			keybind_resource.move_right_key = event
		keybind_resource.JUMP:
			keybind_resource.jump_key = event

func on_keybinds_loaded(data: Dictionary) -> void:
	var loaded_move_left = InputEventKey.new()
	var loaded_move_right = InputEventKey.new()
	var loaded_jump = InputEventKey.new()
	
	loaded_move_left.set_physical_keycode(int(data.move_left))
	loaded_move_right.set_physical_keycode(int(data.move_right))
	loaded_jump.set_physical_keycode(int(data.jump))
	
	keybind_resource.move_left_key = loaded_move_left 
	keybind_resource.move_right_key = loaded_move_right
	keybind_resource.jump_key = loaded_jump

func on_settings_data_loaded(data: Dictionary) -> void:
	loaded_data = data
	#print(loaded_data)
	on_window_mode_selected(loaded_data.window_mode_index)
	on_resolution_selected(loaded_data.resolution_index)
	on_subtitles_set(loaded_data.subtitles_set)
	on_master_sound_set(loaded_data.master_volume)
	on_music_sound_set(loaded_data.music_volume)
	on_sfx_sound_set(loaded_data.sfx_volume)
	on_keybinds_loaded(loaded_data.keybinds)

func handle_signals() -> void:
	SettingsSignalBus.on_window_mode_selected.connect(on_window_mode_selected)
	SettingsSignalBus.on_resolution_selected.connect(on_resolution_selected)
	SettingsSignalBus.on_subtitles_toggled.connect(on_subtitles_set)
	SettingsSignalBus.on_master_sound_set.connect(on_master_sound_set)
	SettingsSignalBus.on_music_sound_set.connect(on_music_sound_set)
	SettingsSignalBus.on_sfx_sound_set.connect(on_sfx_sound_set)
	SettingsSignalBus.load_settings_data.connect(on_settings_data_loaded)

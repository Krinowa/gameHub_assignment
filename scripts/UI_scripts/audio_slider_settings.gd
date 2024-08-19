extends Control

@onready var audio_name_lbl = $HBoxContainer/Audio_Name_Lbl as Label
@onready var audio_num_lbl = $HBoxContainer/Audio_Num_Lbl as Label
@onready var h_slider = $HBoxContainer/HSlider as HSlider

@export_enum("Master", "Music", "SFX") var bus_name: String

var bus_index: int = 0

func _ready():
	# Connect the slider's value_changed signal to the on_value_changed function
	h_slider.value_changed.connect(on_value_changed)
	# Get the bus index based on the bus name
	get_bus_name_by_index()
	# Load the initial volume data for the selected bus
	load_data()
	# Set the text for the audio name label
	set_name_label_text()
	# Set the initial slider value based on the bus volume
	set_slider_value()

# Load the volume data for the selected bus and apply it
func load_data() -> void:
	match bus_name:
		"Master":
			on_value_changed(SettingsContainer.get_master_volume())
		"Music":
			on_value_changed(SettingsContainer.get_music_volume())
		"SFX":
			on_value_changed(SettingsContainer.get_sfx_volume())

# Set the text of the audio name label to reflect the selected bus
func set_name_label_text() -> void:
	audio_name_lbl.text = str(bus_name) + " Volume" 

# Update the audio number label to show the current slider value as a percentage
func set_audio_num_label_text() -> void:
	audio_num_lbl.text = str(h_slider.value * 100) + "%"

# Get the index of the selected bus name from the AudioServer
func get_bus_name_by_index() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

# Set the slider value based on the current volume of the bus
func set_slider_value() -> void:
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	set_audio_num_label_text()

# Handle changes to the slider value
func on_value_changed(value : float) -> void:
	# Set the bus volume in the AudioServer
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	# Update the audio number label to reflect the new value
	set_audio_num_label_text()

	# Emit signals based on the bus index to notify other parts of the system about the volume change
	match bus_index:
		0:
			SettingsSignalBus.emit_on_master_sound_set(value)
		1:
			SettingsSignalBus.emit_on_music_sound_set(value)
		2:
			SettingsSignalBus.emit_on_sfx_sound_set(value)

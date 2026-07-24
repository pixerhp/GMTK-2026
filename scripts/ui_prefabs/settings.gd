extends Control

signal on_back_pressed

var music_volume: float = 1.0
var sfx_volume: float = 1.0

func _ready() -> void:
	%MusicVolSlider.value_changed.connect(_on_music_slider_value_changed)
	%SoundVolSlider.value_changed.connect(_on_sound_slider_value_changed)
	_load_settings()

func _exit_tree() -> void:
	_save_settings()

func _on_back_button_pressed() -> void:
	on_back_pressed.emit()
	_save_settings()
	
func _process(_delta):
	if Input.is_action_just_pressed("fullscreen_toggle"):
		%FullScreenTickbox.button_pressed = Globals.is_fullscreen

func _save_settings() -> void:
	var save_file: FileAccess = FileAccess.open("user://settings.dat", FileAccess.WRITE)
	save_file.store_float(music_volume)
	save_file.store_float(sfx_volume)

	save_file.store_8(1 if Globals.is_fullscreen else 0)
	save_file.flush()
	
func _load_settings() -> void:
	if not FileAccess.file_exists("user://settings.dat"):
		return

	var load_file: FileAccess = FileAccess.open("user://settings.dat", FileAccess.READ)
	music_volume = load_file.get_float()
	sfx_volume = load_file.get_float()

	Globals.is_fullscreen = load_file.get_8()

	_post_load_settings()
	
func _post_load_settings() -> void:
	_on_music_slider_value_changed(music_volume)
	_on_sound_slider_value_changed(sfx_volume)

	_on_full_screen_box_toggled(Globals.is_fullscreen)
	%MusicVolSlider.value = music_volume
	%SoundVolSlider.value = sfx_volume
	
	%FullScreenTickbox.button_pressed = Globals.is_fullscreen

func _on_sound_slider_value_changed(value: float) -> void:
	sfx_volume = value
	var vol_in_db: float = lerpf(-100.0, 0.0, sfx_volume)
	var bus_index: int = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, vol_in_db)

func _on_music_slider_value_changed(value: float) -> void:
	music_volume = value
	var vol_in_db: float = lerpf(-100.0, 0.0, music_volume)
	var bus_index: int = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, vol_in_db)


func _on_full_screen_box_toggled(toggled_on: bool) -> void:
	Globals.set_fullscreen(toggled_on)

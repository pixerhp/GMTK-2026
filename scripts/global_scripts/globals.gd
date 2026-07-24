extends Node

var is_fullscreen: bool = false
func _ready() -> void:
	is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

var window_mode_pre_fullscreen: int = ProjectSettings.get_setting("display/window/size/mode")
func set_fullscreen(value: bool) -> void:
	is_fullscreen = value
	if is_fullscreen:
		if not DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			window_mode_pre_fullscreen = DisplayServer.window_get_mode()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(window_mode_pre_fullscreen)

func _process(_delta):
	# Handle global inputs:
	if Input.is_action_just_pressed("fullscreen_toggle"):
		set_fullscreen(not is_fullscreen)
	# Handle tickbeats:
	process_tickbeats()

signal tickbeat
const TICKBEAT_DURATION: int = 500
var tickbeat_count: int = 0 # (Can be used with modular arithmetic for doing things every n beats or similar.)
var tickbeat_offset: int = 0 # (Offset, usually for making tickbeats line up with when you start playing.)
func process_tickbeats():
	var current_time: int = Time.get_ticks_msec()
	while (current_time > (((tickbeat_count + 1) * TICKBEAT_DURATION) + tickbeat_offset)):
		tickbeat.emit()
		tickbeat_count += 1
		print(tickbeat_count)

func set_music(music_node_name: String) -> void:
	for child in GlobalMusic.get_children():
		child.stop()
	GlobalMusic.get_node(music_node_name).play(0)
	tickbeat_count = 0
	tickbeat_offset = Time.get_ticks_msec()

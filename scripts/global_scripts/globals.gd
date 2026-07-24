extends Node

signal tickbeat
const TICKBEAT_TIMER_DURATION: float = 0.5
var tickbeat_count: int = 0 # (Can be used with modular arithmetic for doing things every n beats or similar.)

var level_start_time: float = 0
var next_beat_time: float = 0
func _on_tickbeat_timer_timeout() -> void:
	tickbeat_count += 1 
	tickbeat.emit()
	next_beat_time = Time.get_ticks_msec() + TICKBEAT_TIMER_DURATION * 1000
	#print("TICKBEAT ", tickbeat_count)

var is_fullscreen: bool = false
func _ready() -> void:
	is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

var window_mode_pre_fullscreen: int = ProjectSettings.get_setting("display/window/size/mode")
func _process(_delta):
	if Time.get_ticks_msec() >= next_beat_time:
		_on_tickbeat_timer_timeout()
	# Handle global inputs:
	if Input.is_action_just_pressed("fullscreen_toggle"):
		set_fullscreen(not is_fullscreen)
	
func set_fullscreen(value: bool) -> void:
	is_fullscreen = value
	if is_fullscreen:
		if not DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			window_mode_pre_fullscreen = DisplayServer.window_get_mode()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(window_mode_pre_fullscreen)

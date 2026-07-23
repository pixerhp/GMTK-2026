extends Node

signal tickbeat
var tickbeat_timer: Timer = Timer.new()
const TICKBEAT_TIMER_DURATION: float = 2.0
var tickbeat_count: int = 0 # (Can be used with modular arithmetic for doing things every n beats or similar.)
func _on_tickbeat_timer_timeout() -> void:
	tickbeat_count += 1 
	tickbeat.emit()
	tickbeat_timer.start(TICKBEAT_TIMER_DURATION)
	#print("TICKBEAT ", tickbeat_count)

func _ready() -> void:
	# Prepare tickbeat timer:
	tickbeat_timer.timeout.connect(_on_tickbeat_timer_timeout)
	add_child(tickbeat_timer)
	tickbeat_timer.start(TICKBEAT_TIMER_DURATION)

var window_mode_pre_fullscreen: int = ProjectSettings.get_setting("display/window/size/mode")
func _process(_delta):
	# Handle global inputs:
	if Input.is_action_just_pressed("fullscreen_toggle"):
		if not DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			window_mode_pre_fullscreen = DisplayServer.window_get_mode()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(window_mode_pre_fullscreen)
	
	# Global tick signal, for synchronized environment/hazard/etc movement:
	

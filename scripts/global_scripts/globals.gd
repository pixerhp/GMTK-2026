extends Node

var window_mode_pre_fullscreen: int = ProjectSettings.get_setting("display/window/size/mode")
func _process(_delta):
	if Input.is_action_just_pressed("fullscreen_toggle"):
		if not DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			window_mode_pre_fullscreen = DisplayServer.window_get_mode()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(window_mode_pre_fullscreen)

extends Control

signal on_back_pressed

func _on_back_button_pressed() -> void:
	on_back_pressed.emit()


func _on_full_screen_box_pressed() -> void:
	if(%BackButton.button_pressed) :
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

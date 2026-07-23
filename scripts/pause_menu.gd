extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	visible = get_tree().paused

func _on_settings_button_pressed() -> void:
	_hide_all()
	$Settings.visible = true

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_back_pressed() -> void:
	_hide_all()
	$PauseMenuVBox.visible = true

func _hide_all() -> void:
	for child in get_children():
		child.visible = false

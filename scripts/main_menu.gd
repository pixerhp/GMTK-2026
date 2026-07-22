extends Control

func _on_play_button_pressed() -> void:
	# TODO: Load game scene
	pass

func _on_settings_button_pressed() -> void:
	_hide_all()
	$Settings.visible = true

func _on_credits_button_pressed() -> void:
	_hide_all()
	$CreditsVBox.visible = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	_hide_all()
	$MainMenuVBox.visible = true

func _hide_all() -> void:
	for child in get_children():
		child.visible = false

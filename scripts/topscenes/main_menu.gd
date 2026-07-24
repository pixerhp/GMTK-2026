extends Control

func _ready() -> void:
	Globals.set_music("TheCountBossBattle")

func _on_play_button_pressed() -> void:
	Globals.set_music("CountMusicStuff")
	get_tree().change_scene_to_file("res://scenes/topscenes/level_one.tscn")

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

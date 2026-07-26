extends Control

func _ready() -> void:
	Globals.set_music("TheCountBossBattle")

func _process(_delta: float):
	if Input.is_action_just_pressed("pause"):
		_on_back_pressed()

func _on_play_button_pressed() -> void:
	Globals.set_music("CountMusicStuff")
	get_tree().change_scene_to_file("res://scenes/topscenes/level_final.tscn")

func _on_settings_button_pressed() -> void:
	%MainMenuButtons.visible = false
	%Settings.visible = true

func _on_credits_button_pressed() -> void:
	%MainMenuButtons.visible = false
	%Credits.visible = true

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	%Settings.visible = false
	%Credits.visible = false
	%MainMenuButtons.visible = true

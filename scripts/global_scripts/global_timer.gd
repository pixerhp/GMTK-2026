extends Node

signal tick_beat

func _ready() -> void:
	get_tree().create_timer(2).timeout.connect(_on_beat)

func _on_beat() -> void:
	tick_beat.emit()
	get_tree().create_timer(2).timeout.connect(_on_beat)

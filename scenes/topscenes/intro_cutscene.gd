extends Control

#var cutsceneCamera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	if(!Globals.is_cutscene_played):
		$AnimationPlayer.play("intro_animation")
	else:
		queue_free()

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	get_tree().paused = true;

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().paused = false;
	Globals.is_cutscene_played = true;
	queue_free()

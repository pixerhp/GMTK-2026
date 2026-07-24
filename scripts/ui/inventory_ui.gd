extends Node

@export var container:Control

var show_time: float = 0
var is_showing: bool = true

func _process(delta: float):
	if Input.is_action_pressed("show_inventory"):
		if show_time < 0.1: show_time = 0.1
	else: show_time -= delta
	
	if (is_showing):
		if (show_time < 0):
			var tween = get_tree().create_tween()
			tween.tween_property(container, "offset_transform_position", Vector2(0, 300), 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
			is_showing = false
	else:
		if (show_time > 0):
			var tween = get_tree().create_tween()
			tween.tween_property(container, "offset_transform_position", Vector2(0, 0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			is_showing = true

func add_item(id:String):
	show_time = 1
	
	var prefab: PackedScene = load("res://scenes/ui/ui_elements/inventory_item.tscn")
	var new: TextureRect = prefab.instantiate()
	new.texture = load("res://assets/placeholder_art/" + id + ".png")
	new.name = id
	new.get_node("Label").text = id
	container.add_child(new);
	
func remove_item(id:String):
	# show_time = 1
	var item : TextureRect = container.get_node_or_null(id)
	# I wanted it to fade away but uhh yeah it was easier to not show inventory at all
	# var tween = get_tree().create_tween()
	# tween.tween_property(item, "modulate.a", 0, 1)
	# tween.tween_property(item, "offset_transform_position.x", -100, 1)
	# tween.tween_callback(item.queue_free)
	item.queue_free()
	
func clear_all_items():
	for x in container.get_children(): x.queue_free()

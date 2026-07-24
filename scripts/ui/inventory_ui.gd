extends Node

func add_item(id:String):
	remove_item(id) # Safe check
	
	var prefab: PackedScene = load("res://scenes/ui/ui_elements/inventory_item.tscn")
	var new: TextureRect = prefab.instantiate()
	new.texture = load("res://assets/placeholder_art/" + id + ".png")
	new.name = id
	new.get_node("Label").text = id
	$Container.add_child(new);
	
func remove_item(id:String):
	var item = get_node(id)
	if (item != null): item.queue_free()
	
func clear_all_items():
	for i in get_child_count():
		get_child(i).queue_free()

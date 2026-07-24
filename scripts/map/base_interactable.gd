extends Node

@export var required_item_id: String
signal on_interacted

func damage_by_player():
	if !required_item_id.is_empty():
		if !%Player.get_node("Inventory").try_use_item(required_item_id): return
	on_interacted.emit()

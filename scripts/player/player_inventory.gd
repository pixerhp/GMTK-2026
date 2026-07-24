extends Node

@onready var ui: Node =  get_node("../../CanvasLayer/MainUI/InventoryUI")
var items: PackedStringArray

func _ready() -> void:
	ui.clear_all_items()
	items.append("test")

func try_add_item(id:String) -> bool:
	if id.is_empty(): return false
	if items.has(id): return false
	
	items.append(id)
	ui.add_item(id)
	return true
	
func try_use_item(id:String) -> bool:
	if !items.has(id): return false
	items.erase(id)
	ui.remove_item(id)
	return true

extends Node

@onready var ui: Node =  get_node("../../CanvasLayer/MainUI/InventoryUI")
var items: PackedStringArray

func _ready():
	if not ui == null:
		ui.clear_all_items()

func try_add_item(id:String) -> bool:
	if id.is_empty(): return false
	if items.has(id): return false
	
	items.append(id)
	ui.add_item(id)
	return true
	
func try_use_item(id:String) -> bool:
	if !items.erase(id): return false
	print("used item " + id)
	ui.remove_item(id)
	return true

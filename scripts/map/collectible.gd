extends Area2D

@export var id: String

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(other):
	var inv = other.get_node("Inventory")
	if inv == null: return
	
	if !inv.try_add_item(id): return
	
	queue_free()

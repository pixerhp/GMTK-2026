extends "res://scripts/map/base_interactable.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	on_interacted.connect(_interacted)
	
func _interacted():
	print("Interacted")

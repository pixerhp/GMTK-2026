extends Node2D

@export var gearDirection: bool = false

# TODO: replace this ready function with when the counter goes to zero, please. - Ray
# this makes the switching
func _ready() -> void:
	_switch_direction()
	GlobalTimer.tick_beat.connect(_switch_direction)

func _switch_direction() -> void:
	if gearDirection == false:
		rotation_degrees = 0
	elif gearDirection == true:
		rotation_degrees = 180
	gearDirection = not gearDirection

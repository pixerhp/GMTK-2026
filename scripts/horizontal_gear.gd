extends Node2D

@export var gearDirection: bool = false
@onready var gearAnim = $AnimatedSprite2D
# TODO: replace this ready function with when the counter goes to zero, please. - Ray
# this makes the switching
func _ready() -> void:
	_switch_direction()
	Globals.tickbeat.connect(_switch_direction)

func _switch_direction() -> void:
	gearAnim.play("horizontalGearTurn")
	if gearDirection == false:
		scale.x = 2
	elif gearDirection == true:
		scale.x = -2
	gearDirection = not gearDirection

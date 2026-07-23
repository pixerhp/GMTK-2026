extends Node2D

@export var gearDirection: bool = false
@onready var gearAnim = $AnimatedSprite2D
# TODO: replace this ready function with when the counter goes to zero, please. - Ray
# this makes the switching
func _ready() -> void:
	_switch_direction()
	GlobalTimer.tick_beat.connect(_switch_direction)

func _switch_direction() -> void:
	gearAnim.play("gearTurn")

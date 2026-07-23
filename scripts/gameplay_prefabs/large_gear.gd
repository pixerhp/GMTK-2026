extends StaticBody2D

@export var gearDirection: bool = false
@export var gearPower: float = 4.0
@onready var gearAnim = $AnimatedSprite2D
# TODO: replace this ready function with when the counter goes to zero, please. - Ray
# this makes the switching
func _ready() -> void:
	_turn_gear()
	Globals.tickbeat.connect(_turn_gear)
	
func _turn_gear() -> void:
	if (Globals.tickbeat_count % 4) == 0:
		gearAnim.play("gearTurn")
		if (gearDirection):
			constant_angular_velocity = gearPower;
		else:
			constant_angular_velocity = -gearPower;
		await get_tree().create_timer(1.0/6.0).timeout
		constant_angular_velocity = 0.0;

extends StaticBody2D

@onready var pendelumAnim = $AnimationPlayer
@export var pendelumPower = 4.0;
@export var pendelumDirection = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_swing_pendelum()
	Globals.tickbeat.connect(_swing_pendelum)


func _swing_pendelum():
	if (Globals.tickbeat_count % 4) == 0:
		if pendelumDirection:
			constant_linear_velocity = Vector2(pendelumPower, 0.0)
			pendelumAnim.play("swing_left")
		else:
			constant_linear_velocity = Vector2(-pendelumPower, 0.0)
			pendelumAnim.play("swing_right")
		constant_linear_velocity = Vector2(0.0, 0.0)
		pendelumDirection = not pendelumDirection

extends StaticBody2D

@onready var pendelum_anim = $AnimationPlayer
@export var pendelumPower = 4.0;
@export var pendelum_direction = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_swing_pendelum()
	Globals.tickbeat.connect(_swing_pendelum)

func _swing_pendelum():
	if (Globals.tickbeat_count % 4) == 0:
		if pendelum_direction:
			constant_linear_velocity = Vector2(pendelumPower, 0.0)
			pendelum_anim.play("swing_left")
		else:
			constant_linear_velocity = Vector2(-pendelumPower, 0.0)
			pendelum_anim.play("swing_right")
		constant_linear_velocity = Vector2(0.0, 0.0)
		pendelum_direction = not pendelum_direction

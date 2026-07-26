extends StaticBody2D

@onready var pendelum_anim = $AnimationPlayer
@export var pendelum_direction = false;

func _ready():
	Globals.tickbeat.connect(_swing_pendelum)
	_swing_pendelum(true)

func _swing_pendelum(force_swing: bool = false):
	if ((Globals.tickbeat_count % 4) == 0) or force_swing:
		if pendelum_direction != bool((Globals.tickbeat_count/4)%2):
			pendelum_anim.play("swing_left")
		else:
			pendelum_anim.play("swing_right")

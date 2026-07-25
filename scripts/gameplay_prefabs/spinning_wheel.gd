extends StaticBody2D

@export var wheel_speed = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(delta * wheel_speed)

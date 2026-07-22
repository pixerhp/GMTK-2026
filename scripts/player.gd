extends CharacterBody2D

@export var SPEED: float = 200.0

func _physics_process(delta: float) -> void:
	velocity.y += 9.8
	if Input.is_action_just_pressed("jump"):
		velocity.y = -300
	velocity.x = Input.get_axis("left", "right") * SPEED
	move_and_slide()

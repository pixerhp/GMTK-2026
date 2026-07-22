extends CharacterBody2D

@export var GRAVITY: float = 9.8
@export var SPEED: float = 200.0
@export var JUMP_VELOCITY: float = 300

var time_since_on_floor: float = 10.0
var time_since_pressed_jump: float = 10.0

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY
	
	time_since_on_floor += delta
	if is_on_floor():
		time_since_on_floor = 0.0
	
	time_since_pressed_jump += delta
	if Input.is_action_just_pressed("jump"):
		time_since_pressed_jump = 0.0
	
	if time_since_pressed_jump < 0.1 and time_since_on_floor < 0.1:
		velocity.y = -JUMP_VELOCITY
		
	velocity.x = Input.get_axis("left", "right") * SPEED
	move_and_slide()

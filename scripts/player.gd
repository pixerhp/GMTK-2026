extends CharacterBody2D

enum LEDGE_GRAB_DIRECTION { NEITHER, LEFT, RIGHT }

@export var GRAVITY: float = 9.8
@export var SPEED: float = 200.0
@export var JUMP_VELOCITY: float = 300

var time_since_on_floor: float = 10.0
var time_since_pressed_jump: float = 10.0

var ledge_grab_cooldown: float = 0.0
var ledge_movement_cooldown: float = 0.0

var was_ledge_grabbing: bool = false

@onready var ledge_left_upper_check: RayCast2D = $LedgeLeftUpperCheck
@onready var ledge_left_lower_check: RayCast2D = $LedgeLeftLowerCheck

@onready var ledge_right_upper_check: RayCast2D = $LedgeRightUpperCheck
@onready var ledge_right_lower_check: RayCast2D = $LedgeRightLowerCheck

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY
	
	ledge_grab_cooldown -= delta
	ledge_grab_cooldown = max(ledge_grab_cooldown, 0.0)
	
	ledge_movement_cooldown -= delta
	ledge_movement_cooldown = max(ledge_movement_cooldown, 0.0)
	
	time_since_on_floor += delta
	if is_on_floor():
		time_since_on_floor = 0.0
	
	time_since_pressed_jump += delta
	if Input.is_action_just_pressed("jump") and ledge_movement_cooldown <= 0.0:
		time_since_pressed_jump = 0.0
		ledge_grab_cooldown = max(ledge_grab_cooldown, 0.01)
	
	if time_since_pressed_jump < 0.1 and time_since_on_floor < 0.1:
		velocity.y = -JUMP_VELOCITY
	
	velocity.x = Input.get_axis("left", "right") * SPEED
	
	var ledge_grabbing: LEDGE_GRAB_DIRECTION = LEDGE_GRAB_DIRECTION.NEITHER
	
	if ledge_left_lower_check.is_colliding() and not ledge_left_upper_check.is_colliding():
		ledge_grabbing = LEDGE_GRAB_DIRECTION.LEFT
		
	if ledge_right_lower_check.is_colliding() and not ledge_right_upper_check.is_colliding():
		ledge_grabbing = LEDGE_GRAB_DIRECTION.RIGHT
	
	if ledge_grabbing != LEDGE_GRAB_DIRECTION.NEITHER and ledge_grab_cooldown <= 0.0:
		if not was_ledge_grabbing:
			ledge_movement_cooldown = 0.2
		was_ledge_grabbing = true
		velocity = Vector2.ZERO
		time_since_on_floor = 0.0
		if ledge_movement_cooldown <= 0.0:
			if Input.is_action_pressed("down"):
				ledge_grab_cooldown = 0.1
			if ledge_grabbing == LEDGE_GRAB_DIRECTION.LEFT:
				if Input.is_action_just_pressed("right"):
					ledge_grab_cooldown = 0.1
				if Input.is_action_just_pressed("left"):
					position += Vector2(-4, -32)
					ledge_grab_cooldown = 0.1
			elif ledge_grabbing == LEDGE_GRAB_DIRECTION.RIGHT:
				if Input.is_action_just_pressed("left"):
					ledge_grab_cooldown = 0.1
				if Input.is_action_just_pressed("right"):
					position += Vector2(4, -32)
					ledge_grab_cooldown = 0.1
	else:
		was_ledge_grabbing = false
		
	move_and_slide()

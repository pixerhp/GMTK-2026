extends CharacterBody2D

# NOTE Experimental script with the aim to give the player better mechanics and movement than 
# the original player script does. (May replace the original script if/when completed.)

@export var GRAVITY: float = 22.0 * 60.0
@export var GRAVITY_MULT_IF_HOLDING_JUMP: float = 0.5
@export var FALL_MAX: float = 400.0
@export var HORIZONTAL_MOVEMENT_UPON_JUMP_MULT: float = 0.8
@export var HORIZONTAL_MOVEMENT_GROUND_ACCEL: float = 15.0 * 60.0
@export var HORIZONTAL_MOVEMENT_GROUND_MAX_SPEED: float = 220.0
@export var HORIZONTAL_MOVEMENT_GROUND_DECEL_WHILE_STOPPING: float = 0.0000001
@export var HORIZONTAL_MOVEMENT_AIR_ACCEL: float = 2.0 * 60.0
@export var HORIZONTAL_MOVEMENT_AIR_DECEL: float = 1.0 / (1.5)
@export var AIR_TURNAROUND_ACCEL: float = 10.0 * 60.0
@export var AIR_TURNAROUND_SPEED_LIMIT: float = 120.0
@export var JUMP_VERTICAL_VELOCITY: float = 300.0
@export var JUMP_SLOWDOWN = 0.9
@export var JUMP_BUFFER_DURATION_MS: int = 100
var jump_buffer_time: int = -99999999
@export var COYOTE_DURATION_MS: int = 100
var jump_coyote_time: int = -99999999

func _physics_process(delta: float) -> void:
	handle_collision_checks()
	handle_inputs_and_movement(delta)
	
	move_and_slide()

func handle_collision_checks():
	if is_on_floor():
		jump_coyote_time = Time.get_ticks_msec()

func handle_inputs_and_movement(delta: float):
	# Gravity application:
	if Input.is_action_pressed("jump"):
		velocity.y += GRAVITY * GRAVITY_MULT_IF_HOLDING_JUMP * delta
	else:
		velocity.y += GRAVITY * delta
	# Jumping:
	if Input.is_action_just_pressed("jump"):
		jump_buffer_time = Time.get_ticks_msec()
	if (
		((Time.get_ticks_msec() - jump_coyote_time) < COYOTE_DURATION_MS) and
		((Time.get_ticks_msec() - jump_buffer_time) < JUMP_BUFFER_DURATION_MS)
	):
		jump_coyote_time = -99999999
		velocity.y = -1.0 * JUMP_VERTICAL_VELOCITY
		velocity.x *= HORIZONTAL_MOVEMENT_UPON_JUMP_MULT
	
	
	if is_on_floor():
		# Ground deceleration:
		if (
			(not (Input.is_action_pressed("move_left") != Input.is_action_pressed("move_right"))) or
			(Input.is_action_pressed("move_left") and (velocity.x > 0.0)) or 
			(Input.is_action_pressed("move_right") and (velocity.x < 0.0))
		):
			velocity.x *= pow(HORIZONTAL_MOVEMENT_GROUND_DECEL_WHILE_STOPPING, delta)
		# Ground acceleration:
		if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			velocity.x -= HORIZONTAL_MOVEMENT_GROUND_ACCEL * delta
		if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
			velocity.x += HORIZONTAL_MOVEMENT_GROUND_ACCEL * delta
		# Ground speed limit:
		if abs(velocity.x) > HORIZONTAL_MOVEMENT_GROUND_MAX_SPEED:
			velocity.x = HORIZONTAL_MOVEMENT_GROUND_MAX_SPEED * (-1.0 if (velocity.x < 0.0) else 1.0)
	else:
		# Air deceleration:
		velocity.x *= pow(HORIZONTAL_MOVEMENT_AIR_DECEL, delta)
		# Air acceleration:
		if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			if velocity.x < (-1.0 * AIR_TURNAROUND_SPEED_LIMIT):
				velocity.x -= HORIZONTAL_MOVEMENT_AIR_ACCEL * delta
			else:
				velocity.x -= AIR_TURNAROUND_ACCEL * delta
		if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
			if velocity.x > AIR_TURNAROUND_SPEED_LIMIT:
				velocity.x += HORIZONTAL_MOVEMENT_AIR_ACCEL * delta
			else:
				velocity.x += AIR_TURNAROUND_ACCEL * delta
	
	#if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		#if is_on_floor():
			#velocity.x -= HORIZONTAL_MOVEMENT_GROUND_ACCEL * delta
			#print(velocity.x)
		#else:
			#velocity.x -= HORIZONTAL_MOVEMENT_AIR_ACCEL * delta
	#elif Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		#if is_on_floor():
			#pass
		#else:
			#pass
	
	if velocity.y < (-1.0 * FALL_MAX):
		velocity.y = -1.0 * FALL_MAX

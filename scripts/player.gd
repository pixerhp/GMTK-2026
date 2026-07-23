extends CharacterBody2D

enum LEDGE_GRAB_DIRECTION { NEITHER, LEFT, RIGHT }

@export var GRAVITY: float = 9.8
@export var SPEED: float = 180.0
@export var JUMP_VELOCITY: float = 200.0
@export var ACCELERATION: float = 60.0
@export var FRICTION: float = 500.0
@export var JUMP_SLOWDOWN = 0.5

var time_since_on_floor: float = 10.0
var time_since_pressed_jump: float = 10.0

var ledge_grab_cooldown: float = 0.0
var ledge_movement_cooldown: float = 0.0

var was_ledge_grabbing: bool = false

@onready var ledge_left_upper_check: RayCast2D = $LedgeLeftUpperCheck
@onready var ledge_left_lower_check: RayCast2D = $LedgeLeftLowerCheck

@onready var ledge_right_upper_check: RayCast2D = $LedgeRightUpperCheck
@onready var ledge_right_lower_check: RayCast2D = $LedgeRightLowerCheck

@onready var attack_area: Area2D = $DamageArea
@onready var attack_sprite: Sprite2D = $DamageArea/Sprite

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
	if !Input.is_key_pressed(KEY_SPACE) && velocity.y < 0:
		velocity.y *= JUMP_SLOWDOWN
	
	var move_intent: float = Input.get_axis("left", "right")
	if(abs(velocity.x) < SPEED) :
		velocity.x += move_intent * ACCELERATION
	if(move_intent == 0.0 || move_intent == -sign(velocity.x)) :
		# Stop player from going on an ice skating rink
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	var ledge_grabbing: LEDGE_GRAB_DIRECTION = LEDGE_GRAB_DIRECTION.NEITHER
	
	if ledge_left_lower_check.is_colliding() and not ledge_left_upper_check.is_colliding():
		ledge_grabbing = LEDGE_GRAB_DIRECTION.LEFT
		
	if ledge_right_lower_check.is_colliding() and not ledge_right_upper_check.is_colliding():
		ledge_grabbing = LEDGE_GRAB_DIRECTION.RIGHT
	
	if ledge_grabbing != LEDGE_GRAB_DIRECTION.NEITHER and ledge_grab_cooldown <= 0.0 and velocity.y >= 0:
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
	if velocity.x and move_intent:
		var movingRight = move_intent > 0
		$Sprite2D.flip_h = !movingRight
		attack_sprite.flip_h = !movingRight
		if (movingRight):
			attack_area.position.x = 14
		else: attack_area.position.x = -14
		
	move_and_slide()

# TODO: Handle deaths better
func _on_hurt_box_body_entered(_body: Node2D) -> void:
	print("Player died")
	get_tree().call_deferred("reload_current_scene")

extends CharacterBody2D

# NOTE Experimental script with the aim to give the player better mechanics and movement than 
# the original player script does. (May replace the original script if/when completed.)

@export var GRAVITY: float = 22.0 * 60.0
@export var GRAVITY_MULT_IF_HOLDING_JUMP: float = 0.5
@export var FALL_SPEED_MAX: float = 600.0
@export var HORIZONTAL_MOVEMENT_UPON_JUMP_MULT: float = 0.8
@export var HORIZONTAL_MOVEMENT_GROUND_ACCEL: float = 20.0 * 60.0
@export var HORIZONTAL_MOVEMENT_GROUND_MAX_SPEED: float = 220.0
@export var HORIZONTAL_MOVEMENT_GROUND_DECEL_WHILE_STOPPING: float = 0.0000000001
@export var HORIZONTAL_MOVEMENT_AIR_ACCEL: float = 2.25 * 60.0
@export var HORIZONTAL_MOVEMENT_AIR_DECEL: float = 1.0 / (1.5)
@export var AIR_TURNAROUND_ACCEL: float = 10.0 * 60.0
@export var AIR_TURNAROUND_SPEED_LIMIT: float = 120.0
@export var JUMP_VERTICAL_VELOCITY: float = 300.0
@export var JUMP_SLOWDOWN = 0.9
@export var JUMP_BUFFER_DURATION_MS: int = 100
var jump_buffer_time: int = -99999999
@export var COYOTE_DURATION_MS: int = 100
var jump_coyote_time: int = -99999999

var is_facing_right: bool = true

var is_ledge_hit: bool = false
var ledge_hit_point: Vector2
var ledge_hit_node: Node2D

var holding_ledge: bool = false

var grab_point_marker: Marker2D = Marker2D.new()

var attackTimeLeft: float = 0
var isAttacking: bool = false

func _ready() -> void:
	%DamageArea.body_entered.connect(_on_weapon_hit_body)
	%HurtBox.body_entered.connect(_on_hurt_box_body_entered)

func _process(_delta):
	%CharacterSprite.flip_h = not is_facing_right
	%PlayerCam.position.y = Input.get_axis("move_up", "move_down") * 100

func _physics_process(delta: float) -> void:
	handle_collision_checks()
	handle_inputs_and_movement(delta)
	
	handle_ledges()
	%CharacterSprite.animation = "walk" if Input.get_axis("move_left", "move_right") != 0 else "idle"
	
	handle_weapon(delta)
	
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
	# Vertical speed limits:
	if (velocity.y > FALL_SPEED_MAX):
		velocity.y = FALL_SPEED_MAX
	
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
			is_facing_right = false
			velocity.x -= HORIZONTAL_MOVEMENT_GROUND_ACCEL * delta
		if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
			is_facing_right = true
			velocity.x += HORIZONTAL_MOVEMENT_GROUND_ACCEL * delta
		# Ground speed limit:
		if abs(velocity.x) > HORIZONTAL_MOVEMENT_GROUND_MAX_SPEED:
			velocity.x = HORIZONTAL_MOVEMENT_GROUND_MAX_SPEED * (-1.0 if (velocity.x < 0.0) else 1.0)
	else:
		# Air deceleration:
		velocity.x *= pow(HORIZONTAL_MOVEMENT_AIR_DECEL, delta)
		# Air acceleration:
		if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			is_facing_right = false
			if velocity.x < (-1.0 * AIR_TURNAROUND_SPEED_LIMIT):
				velocity.x -= HORIZONTAL_MOVEMENT_AIR_ACCEL * delta
			else:
				velocity.x -= AIR_TURNAROUND_ACCEL * delta
		if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
			is_facing_right = true
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


func handle_ledges() -> void:
	if is_facing_right:
		%LedgeUpperCheck.position.x = abs(%LedgeUpperCheck.position.x)
		%LedgeLowerCheck.position.x = abs(%LedgeLowerCheck.position.x)
		
		%LedgeUpperCheck.target_position.x = abs(%LedgeUpperCheck.target_position.x)
		%LedgeLowerCheck.target_position.x = abs(%LedgeLowerCheck.target_position.x)
	else:
		%LedgeUpperCheck.position.x = -abs(%LedgeUpperCheck.position.x)
		%LedgeLowerCheck.position.x = -abs(%LedgeLowerCheck.position.x)
		
		%LedgeUpperCheck.target_position.x = -abs(%LedgeUpperCheck.target_position.x)
		%LedgeLowerCheck.target_position.x = -abs(%LedgeLowerCheck.target_position.x)
	
	%LedgeUpperCheck.force_raycast_update()
	%LedgeLowerCheck.force_raycast_update()
	
	is_ledge_hit = %LedgeLowerCheck.is_colliding() and not %LedgeUpperCheck.is_colliding()
	if is_ledge_hit:
		ledge_hit_point = %LedgeLowerCheck.get_collision_point()
		ledge_hit_node = %LedgeLowerCheck.get_collider()
		
	if not holding_ledge and is_ledge_hit and velocity.y > 0:
		if ledge_hit_node is TileMapLayer:
			var tm: TileMapLayer = ledge_hit_node
			var tile_position: Vector2 = tm.to_global(tm.map_to_local(tm.local_to_map(tm.to_local(ledge_hit_point))))
			var tile_size: Vector2 = tm.to_global(tm.map_to_local(Vector2i.ONE) - tm.map_to_local(Vector2i.ZERO))
			if grab_point_marker.get_parent():
				grab_point_marker.get_parent().remove_child(grab_point_marker)
			grab_point_marker.global_position = tile_position
			grab_point_marker.global_position -= tile_size / 2
			tm.add_child(grab_point_marker)
			holding_ledge = true
		else:
			if grab_point_marker.get_parent():
				grab_point_marker.get_parent().remove_child(grab_point_marker)
			ledge_hit_node.add_child(grab_point_marker)
			if is_facing_right:
				grab_point_marker.position = Vector2(-10, -10)
			else:
				grab_point_marker.position = Vector2(10, -10)
			holding_ledge = true
	
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		holding_ledge = false
	if Input.is_action_just_pressed("jump"):
		holding_ledge = false
	if holding_ledge:
		global_position = grab_point_marker.global_position - %LedgeUpperCheck.position
		velocity = Vector2.ZERO
		jump_coyote_time = Time.get_ticks_msec()


func handle_weapon(delta: float) -> void:
	if is_facing_right:
		%DamageArea.position.x = abs(%DamageArea.position.x)
	else:
		%DamageArea.position.x = -abs(%DamageArea.position.x)
	%DamageSprite.flip_h = !is_facing_right
	
	if !isAttacking && Input.is_action_just_pressed("attack"):
		attackTimeLeft = 0.3
	else:
		attackTimeLeft -= delta
	
	if isAttacking:
		if attackTimeLeft < 0:
			isAttacking = false
			%DamageSprite.visible = false
			%DamageCollider.disabled = true
	else:
		if attackTimeLeft > 0:
			isAttacking = true
			%DamageSprite.visible = true
			%DamageCollider.disabled = false

func _on_weapon_hit_body(body: Node2D):
	if body.has_method("damage_by_player"):
		body.damage_by_player(get_parent())


# TODO: Handle deaths better
func _on_hurt_box_body_entered(_body: Node2D) -> void:
	print("Player died")
	get_tree().call_deferred("reload_current_scene")

extends CharacterBody2D

# choices for bat behaviors.
@export_enum("Chase", "Horizontal Move", "Vertical Move") var behavior_choice: int = 0
@onready var player_range = $BatSprite/PlayerDetection
var move_speed: int = 30
var move_execute: int = 0
@export var move_direction: int = 1 ## 1 equals moving either right or up, -1 for opposite, please ensure this is not set to zero, I am unsure what happens.
var target = null
var in_chase = false
@onready var wall_ray_up = $VerticalWallDetectionUp
@onready var wall_ray_down = $VerticalWallDetectionDown
@onready var wall_ray_left = $HorizontalWallDetectionLeft
@onready var wall_ray_right = $HorizontalWallDetectionRight
var health: int = 2
var desiredPos: Vector2
var iFrames: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_reset_move()
	Globals.tickbeat.connect(_reset_move)
	desiredPos = Vector2(position.x, position.y)

func _reset_move() -> void:
	if (Globals.tickbeat_count % 4) == 0:
		move_execute = move_speed

# TODO: on Behavior 1 and Behavior 2, ensure they follow as the Enum says, making a back and forth hard coded pattern of direction!
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if move_execute >= 1:
		move_execute -= 1
	# Chase Behavior
	if behavior_choice == 0:
		if in_chase == true:
			if target.global_position.x > global_position.x:
				velocity.x += (move_execute * 0.7)
			if target.global_position.x < global_position.x:
				velocity.x -= (move_execute * 0.7)
			if target.global_position.y > global_position.y:
				velocity.y += (move_execute * 0.7)
			if target.global_position.y < global_position.y:
				velocity.y -= (move_execute * 0.7)
		elif in_chase == false:
			velocity.x += randi_range(-move_execute, move_execute)
			velocity.y += randi_range(-move_execute, move_execute)
	
	# Horizontal moving behavior.
	if behavior_choice == 1:
		velocity.x += (move_execute * move_direction)
		# Move towards desired Y value so as not to leave the intended portion of the level
		if(abs(desiredPos.y - position.y) > 5) :
			velocity.y += sign(desiredPos.y - position.y) * move_execute
		if wall_ray_left.is_colliding():
			move_direction = 1
		if wall_ray_right.is_colliding():
			move_direction = -1
	# Vertical moving behavior.
	if behavior_choice == 2:
		velocity.y += (move_execute * move_direction)
		if(abs(desiredPos.x - position.x) > 5) :
			velocity.x += sign(desiredPos.x - position.x) * move_execute
		if wall_ray_up.is_colliding():
			move_direction = 1
		if wall_ray_down.is_colliding():
			move_direction = -1
		
	# regardless of behavior, this is the decay of their movement.
	velocity.x *= 0.9
	velocity.y *= 0.9
	move_and_slide()
	if(iFrames > 0) :
		iFrames -= 1;


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = body
		in_chase = true

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = null
		in_chase = false

# TODO: someone please check on this code, sometimes the bat multiplies its speed and crashes 
# into the player and I swear I didn't mess with this initially, 
# I only flipped variables and its a remedy. - Ray
func damage_by_player(player: Node2D) -> void:
	if(iFrames <= 0) :
		velocity += player.global_position.direction_to(global_position) * -500
		health -= 1
		iFrames = 30;
		if health == 0:
			queue_free()

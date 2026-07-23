extends CharacterBody2D

# choices for bat behaviors.
@export_enum("Chase", "Horizontal Move", "Vertical Move") var behavior_choice: int = 0
@onready var playerRange = $BatSprite/PlayerDetection
var move_speed: int = 30
var move_execute: int = 0
@export var move_direction: int = 1 ## 1 equals moving either right or up, -1 for opposite, please ensure this is not set to zero, I am unsure what happens.
var target = null
var in_chase = false

var health: int = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_reset_move()
	Globals.tickbeat.connect(_reset_move)

func _reset_move() -> void:
	if (Globals.tickbeat_count % 4) == 0:
		move_execute = move_speed

# TODO: on Behavior 1 and Behavior 2, ensure they follow as the Enum says, making a back and forth hard coded pattern of direction!
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
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
		if is_on_wall():
			print("Collided")
			move_direction * -1
	# Vertical moving behavior.
	if behavior_choice == 2:
		pass
		
	# regardless of behavior, this is the decay of their movement.
	velocity.x *= 0.9
	velocity.y *= 0.9
	move_and_slide()


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = body
		in_chase = true

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = null
		in_chase = false

func damage_by_player(player: Node2D) -> void:
	velocity += player.global_position.direction_to(global_position) * 500
	health -= 1
	if health == 0:
		queue_free()

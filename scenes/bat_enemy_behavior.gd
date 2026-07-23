extends CharacterBody2D

# choices for bat behaviors.
@export_enum("Chase", "Horizontal Move", "Vertical Move") var behaviorChoice: int = 0
@onready var playerRange = $BatSprite/PlayerDetection
var moveSpeed: int = 30
var moveExecute: int = 0
var moveDirection: bool = 0
var target = null
var inChase = false

var health: int = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_reset_Move()
	GlobalTimer.tick_beat.connect(_reset_Move)
	

func _reset_Move() -> void:
	moveExecute = moveSpeed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if moveExecute >= 1:
		moveExecute -= 1
	if behaviorChoice == 0:
		if inChase == true:
			if target.global_position.x > global_position.x:
				velocity.x += (moveExecute * 0.5)
			if target.global_position.x < global_position.x:
				velocity.x -= (moveExecute * 0.5)
			if target.global_position.y > global_position.y:
				velocity.y += (moveExecute * 0.5)
			if target.global_position.y < global_position.y:
				velocity.y -= (moveExecute * 0.5)
	velocity.x *= 0.9
	velocity.y *= 0.9
	if behaviorChoice == 1:
		pass
	if behaviorChoice == 2:
		pass
		
	move_and_slide()


func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = body
		inChase = true

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = null
		inChase = false

func damage_by_player() -> void:
	health -= 1
	if health == 0:
		queue_free()

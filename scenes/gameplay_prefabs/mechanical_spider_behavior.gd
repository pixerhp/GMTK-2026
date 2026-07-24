extends CharacterBody2D

# setting up simple variables, reusing spider behavior...
var move_speed: int = 200
@export var move_direction: int = 1 ## 1 equals moving either right, -1 for opposite, please ensure this is not set to zero, I am unsure what happens.
var health: int = 4
var is_in_moving: bool = false
@onready var wall_left_ray = $WallLeftRay
@onready var wall_right_ray = $WallRightRay
@onready var ledge_left_ray = $LedgeLeftRay
@onready var ledge_right_ray = $LedgeRightRay
@onready var spider_sprite = $SpiderSprite
@onready var spider_collision = $SpiderCollisionBody/CollisionShape2D
var animation_state: String = "Idle"
# base counter behaviorwall_left_ray
func _ready() -> void:
	_reset_move()
	Globals.tickbeat.connect(_reset_move)

# adds a on and off switch for if the spider moves via counter rather than pulses.
func _reset_move() -> void:
	if health > 0:
		spider_sprite.stop()
		spider_sprite.play(animation_state)
		if (Globals.tickbeat_count % 4) == 0:
			if is_in_moving:
				is_in_moving = false
				spider_collision.disabled = true
			else:
				is_in_moving = true
				spider_collision.disabled = false

func _physics_process(delta: float) -> void:
	if health > 0:
		if is_in_moving:
			spider_sprite.animation = "Sprint"
			velocity.x = move_speed * move_direction
			if move_direction == -1:
				spider_sprite.flip_h = false
			else: 
				spider_sprite.flip_h = true
		else:
			spider_sprite.animation = "Idle"
			velocity.x = 0
		# switching directions
		if wall_left_ray.is_colliding() or not ledge_left_ray.is_colliding():
			move_direction = 1
		if wall_right_ray.is_colliding() or not ledge_right_ray.is_colliding():
			move_direction = -1
		if not is_on_floor():
			velocity.y += get_gravity().y
		
		move_and_slide()


func damage_by_player(player: Node2D) -> void:
	velocity += player.global_position.direction_to(global_position) * 1000
	health -= 1
	if health < 1:
		spider_collision.disabled = true
		spider_sprite.frame = 0
		spider_sprite.animation = "Death"
		await get_tree().create_timer(5.0).timeout
		queue_free()

extends CharacterBody2D
#TODO: make this not just a copy paste of the spider code


# setting up simple variables, reusing spider behavior...
var move_speed: int = 100
@export var move_direction: int = 1 ## 1 equals moving either right, -1 for opposite, please ensure this is not set to zero, I am unsure what happens.
var health: int = 4
var is_in_moving: bool = false
var knockback: bool = false
@onready var wall_left_ray = $WallLeftRay
@onready var wall_right_ray = $WallRightRay
@onready var ledge_left_ray = $LedgeLeftRay
@onready var ledge_right_ray = $LedgeRightRay
@onready var dracula_sprite = $CountSprite
@onready var dracula_collision = $CountCollisionBody/CollisionShape2D
var animation_state: String = "Idle"

@onready var death_floor: float = position.y + 10
# base counter behaviorwall_left_ray
func _ready() -> void:
	_reset_move()
	Globals.tickbeat.connect(_reset_move)

# adds a on and off switch for if the spider moves via counter rather than pulses.
func _reset_move() -> void:
	if health > 0:
		dracula_sprite.stop()
		dracula_sprite.play(animation_state)
		if (Globals.tickbeat_count % 4) == 0:
			if is_in_moving:
				is_in_moving = false
				dracula_collision.disabled = true
			else:
				is_in_moving = true
				dracula_collision.disabled = false

func _physics_process(delta: float) -> void:
	if health > 0:
		if is_in_moving and not knockback:
			#dracula_sprite.animation = "Sprint"
			velocity.x = move_speed * move_direction
			if move_direction == -1:
				dracula_sprite.flip_h = true
			else: 
				dracula_sprite.flip_h = false
		elif knockback:
			pass
		else:
			dracula_sprite.animation = "Idle"
			velocity.x = 0
		# switching directions
		if wall_left_ray.is_colliding() or not ledge_left_ray.is_colliding():
			move_direction = 1
		if wall_right_ray.is_colliding() or not ledge_right_ray.is_colliding():
			move_direction = -1
			
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		
	if position.y > death_floor:
		health = 0
		damage_by_player(self)
		
	move_and_slide()


func damage_by_player(player: Node2D) -> void:
	if health == 0:
		dracula_collision.disabled = true
		dracula_sprite.frame = 0
		dracula_sprite.animation = "Death"
		Globals.set_music("Stop")
		get_tree().create_timer(3.0).timeout.connect(end_game)
	else:
		velocity -= player.global_position.direction_to(global_position) * -300
		knockback = true
		await get_tree().create_timer(0.2).timeout
		knockback = false

func end_game() -> void:
	Globals.boss_dead()
	Globals.set_music("Credits")
	get_tree().change_scene_to_file("res://scenes/topscenes/win_screen.tscn")
	queue_free()

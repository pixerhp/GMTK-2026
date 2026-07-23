extends Area2D

@onready var collider: CollisionShape2D = $Collider
@onready var sprite: Sprite2D = $Sprite

var attackTimeLeft: float = 0
var isAttacking: bool = false
func _ready():
	body_entered.connect(on_body_entered)

func _process(delta):
	if !isAttacking && Input.is_action_just_pressed("attack"): attackTimeLeft = 0.3
	else: attackTimeLeft -= delta
	
	if isAttacking:
		if attackTimeLeft < 0: toggle_attacking(false)
	else:
		if attackTimeLeft > 0: toggle_attacking(true)
			
func toggle_attacking(attacking:bool):
	isAttacking = attacking
	sprite.visible = attacking
	collider.disabled = !attacking

func on_body_entered(body):
	if body.has_method("damage_by_player"):
		body.damage_by_player(get_parent())

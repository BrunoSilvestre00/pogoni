extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -900.0

@onready var movement_sprites: AnimatedSprite2D = $MovementSprites
@onready var attack_sprites: AnimatedSprite2D = $AttackSprites

@onready var collision_head_l: CollisionShape2D = $CollisionHeadLeft
@onready var collision_head_r: CollisionShape2D = $CollisionHeadRight
@onready var collision_body_l: CollisionShape2D = $CollisionBodyLeft
@onready var collision_body_r: CollisionShape2D = $CollisionBodyRight

@onready var collision_hitbox_left: CollisionShape2D = $SideAttackHitbox/CollisionHitboxLeft
@onready var collision_hitbox_right: CollisionShape2D = $SideAttackHitbox/CollisionHitboxRight

var is_attacking: bool = false
var facing_right: bool = false

func flip() -> void:
	movement_sprites.flip_h = facing_right
	attack_sprites.flip_h = facing_right
	
	attack_sprites.offset = Vector2(-17+64, -4) if facing_right else Vector2(44-64, -4)
	
	collision_head_r.disabled = not facing_right
	collision_body_r.disabled = not facing_right
	
	collision_head_l.disabled = facing_right
	collision_body_l.disabled = facing_right
	
	collision_hitbox_left.disabled = collision_hitbox_left.disabled || facing_right
	collision_hitbox_right.disabled = collision_hitbox_right.disabled || not facing_right
	
func _setup_attack(do: bool) -> void:
	is_attacking = do
	attack_sprites.visible = do
	movement_sprites.visible = not do
	collision_hitbox_left.disabled = not do
	collision_hitbox_right.disabled = not do
	
func make_attack() -> void:
	_setup_attack(true)
	
func stop_attack() -> void:
	_setup_attack(false)

func resolve_animation(direction: float, attack: bool) -> void:
	facing_right = direction > 0 || (movement_sprites.flip_h && direction == 0)
	
	if attack:
		make_attack()
		return attack_sprites.play("side_attack")
	
	if not is_on_floor():
		return movement_sprites.play("fall" if velocity.y > 0 else "fly")
	
	return movement_sprites.play("idle" if direction == 0 else "run")

func _physics_process(delta: float) -> void:
	var jump_key = Input.is_action_just_pressed("jump")
	var atack_key = Input.is_action_just_pressed("attack")
	var direction := Input.get_axis("move_left", "move_right")
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if jump_key and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if not is_attacking:
		resolve_animation(direction, atack_key)
		
	flip()
	move_and_slide()

func _on_attack_sprites_animation_finished() -> void:
	stop_attack()

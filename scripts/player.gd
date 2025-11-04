extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -900.0

@onready var movement_sprites: AnimatedSprite2D = $MovementSprites
@onready var collision_body: CollisionShape2D = $CollisionBody
@onready var collision_side_attack: CollisionShape2D = $CollisionSideAttack

var facing_right: bool = false
var is_attacking: bool = false

func flip() -> void:
	movement_sprites.flip_h = facing_right
	if facing_right == (collision_side_attack.position.x < 0):
		collision_side_attack.position.x *= -1
	
func resolve_attack():
	collision_side_attack.disabled = not is_attacking

func resolve_animation(direction: float) -> void:
	if is_attacking:
		return movement_sprites.play("side-attack")
	if not is_on_floor():
		return movement_sprites.play("fall" if velocity.y > 0 else "fly")
	return movement_sprites.play("idle" if not direction else "walk")

func _physics_process(delta: float) -> void:
	var jump_key := Input.is_action_just_pressed("jump")
	var atack_key := Input.is_action_just_pressed("attack")
	var direction := Input.get_axis("move_left", "move_right")
	
	facing_right = direction > 0 || (movement_sprites.flip_h && direction == 0)
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if jump_key and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if atack_key:
		is_attacking = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	resolve_attack()
	resolve_animation(direction)	
	flip()
	move_and_slide()


func _on_movement_sprites_animation_finished() -> void:
	is_attacking = false

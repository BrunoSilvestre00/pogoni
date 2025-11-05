extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -900.0

const CAM_SPEED = 6.0
const LOOK_OFFSET = 80.0
const LOOK_DELAY = 1.0

@onready var camera: Camera2D = $Camera2D

@onready var movement_sprites: AnimatedSprite2D = $MovementSprites
@onready var collision_body: CollisionShape2D = $CollisionBody

@onready var collision_side_attack: CollisionShape2D = $SideAttackHitbox/CollisionAttack
@onready var light_side_attack: PointLight2D = $SideAttackHitbox/LightAttack

@onready var collision_down_attack: CollisionPolygon2D = $DownAttackHitbox/CollisionAttack
@onready var light_down_attack: PointLight2D = $DownAttackHitbox/LightAttack

var facing_right: bool = false
var is_attacking: bool = false

var look_up_timer: float = 0.0
var look_down_timer: float = 0.0

func is_animating_attack() -> bool:
	return is_attacking and movement_sprites.animation in ["down-attack", "side-attack"]
	
func fall(delta: float) -> void:
	velocity += get_gravity() * delta
	
func jump(intensity: float = 1) -> void:
	velocity.y = JUMP_VELOCITY * intensity
	
func move(direction: float) -> void:
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
func flip() -> void:
	movement_sprites.flip_h = facing_right
	if facing_right == (collision_side_attack.position.x < 0):
		collision_side_attack.position.x *= -1
		light_side_attack.position.x *= -1
	
func resolve_attack(down: bool) -> void:
	collision_side_attack.disabled = not is_attacking or down
	collision_down_attack.disabled = not is_attacking or not down or is_on_floor()
	
	light_side_attack.visible = not collision_side_attack.disabled
	light_down_attack.visible = not collision_down_attack.disabled

func resolve_animation(direction: float, down: bool, up: bool) -> void:
	if is_attacking:
		return movement_sprites.play("down-attack" if down and not is_on_floor() else "side-attack")
	if not is_on_floor():
		return movement_sprites.play("fall" if velocity.y > 0 else "fly")
	if direction:
		return movement_sprites.play("walk")
	if up:
		return movement_sprites.play("look-up")
	if down:
		return movement_sprites.play("look-down")
	return movement_sprites.play("idle")
	
func resolve_camera(delta: float, down: bool, up: bool) -> void:
	if not is_on_floor():
		look_up_timer = 0
		look_down_timer = 0
		return
	
	look_up_timer += delta if up else -look_up_timer
	look_down_timer += delta if down else -look_down_timer
	
	var to = Vector2(0, LOOK_OFFSET*int(look_down_timer >= LOOK_DELAY) - LOOK_OFFSET*int(look_up_timer >= LOOK_DELAY))
	camera.offset = camera.offset.lerp(to, CAM_SPEED * delta)

func _physics_process(delta: float) -> void:
	var jump_key := Input.is_action_just_pressed("jump")
	var atack_key := Input.is_action_just_pressed("attack")
	var down_key := Input.is_action_pressed("down")
	var up_key := Input.is_action_pressed("up")
	var direction := Input.get_axis("left", "right")
	
	facing_right = direction > 0 || (movement_sprites.flip_h && direction == 0)
	
	if atack_key:
		is_attacking = true
	
	if not is_on_floor():
		fall(delta)

	if jump_key and is_on_floor():
		jump()
	
	if not is_animating_attack():
		resolve_attack(down_key)
		resolve_animation(direction, down_key, up_key)
		flip()
		
	resolve_camera(delta, down_key, up_key)
	move(direction)
	move_and_slide()

func _on_movement_sprites_animation_finished() -> void:
	is_attacking = false

func _on_down_attack_hitbox_area_entered(_area: Area2D) -> void:
	jump(0.75)

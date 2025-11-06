extends Area2D

@onready var sprites: AnimatedSprite2D = $Sprites
@onready var light: PointLight2D = $Light
@onready var fire_collision: CollisionShape2D = $FireCollision

@export var start_torch := false

func activate_torch() -> void:
	sprites.play("activated")
	light.color = Color("#961AC8")
	light.energy = 1
	fire_collision.disabled = true
	GameManager.score().increase_score()
	
func deactivate_torch() -> void:
	sprites.play("deactivated")
	light.color = Color("#FD8101")
	light.energy = 1.25
	fire_collision.disabled = false
	GameManager.score().increase_score()

func is_initial_completed() -> bool:
	return GameManager.score().get_score() >= 4

func _process(_delta):
	var enabled: bool = not start_torch or is_initial_completed()
	self.visible = enabled
	self.monitorable = enabled
	self.monitoring = enabled

func _on_area_entered(area: Area2D) -> void:
	if area.name in ['DownAttackHitbox', 'SideAttackHitbox']:
		call_deferred("activate_torch")

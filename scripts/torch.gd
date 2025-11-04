extends Area2D

@onready var sprites: AnimatedSprite2D = $Sprites
@onready var light: PointLight2D = $Light
@onready var fire_collision: CollisionShape2D = $FireCollision

func activate_torch() -> void:
	sprites.play("activated")
	light.color = Color("#961AC8")
	light.energy = 0.75
	fire_collision.disabled = true

func _on_area_entered(_area: Area2D) -> void:
	activate_torch()

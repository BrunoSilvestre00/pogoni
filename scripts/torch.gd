extends Area2D

@onready var sprites: AnimatedSprite2D = $Sprites

func activate_torch() -> void:
	sprites.play("activated")

func _on_area_entered(_area: Area2D) -> void:
	activate_torch()

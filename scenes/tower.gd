extends Node

const SCORE_TRIGGER: int = 5

@onready var game_manager: Node = %GameManager
@onready var bg: TileMapLayer = $BG
@onready var structure: TileMapLayer = $Structure
@onready var details: TileMapLayer = $Details

const TILEMAP_COLOR_FILTERS = {
	0: Color(1.0, 1.0, 1.0),
	1: Color(1.0, 0.2, 0.2),
	2: Color(0.0, 0.9, 0.8),
	3: Color(0.0, 0.2, 0.9),
}

const COLORS_SIZE: int = len(TILEMAP_COLOR_FILTERS)

func resolve_color(key: int) -> void:
	var tiles: Array[TileMapLayer] = [
		bg, structure, details
	]
	var tween = create_tween().set_parallel(true)
	for tile in tiles:
		tween.tween_property(tile, "modulate", TILEMAP_COLOR_FILTERS[key], 0.5)

func _process(_delta):
	var score: int = game_manager.score.get_score()
	
	@warning_ignore("integer_division")
	resolve_color(int(score / SCORE_TRIGGER) % COLORS_SIZE)

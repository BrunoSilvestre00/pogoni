extends Node

var score: int = 0

func increase_score(amount: int = 1) -> void:
	score += amount

func get_score() -> int:
	return score

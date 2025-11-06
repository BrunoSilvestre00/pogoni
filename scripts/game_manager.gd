extends Node

class Score:
	var count: int = 0
	
	func get_score() -> int:
		return self.count
		
	func reset_score() -> void:
		self.count = 0
		
	func increase_score(amount: int = 1) -> void:
		self.count += amount
		if not self.count % 10:
			self.count += 10

var _score: Score = Score.new()

func score() -> Score:
	return _score

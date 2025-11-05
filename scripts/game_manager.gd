extends Node

class Score:
	var count: int = 0
	
	func get_score() -> int:
		return self.count
		
	func is_initial_completed() -> bool:
		return self.count >= 4
		
	func reset_score() -> void:
		self.count = 0
	
	func increase_score() -> void:
		self.count += 1
		if not self.count % 10:
			self.count += 10

var score: Score = Score.new()

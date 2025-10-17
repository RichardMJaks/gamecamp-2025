extends Resource
class_name LevelData

var time_spent: float
var collectibles_collected: int

func _to_string() -> String:
	return "(Time spent: %02d | Collectibles_collected: %02d)" % [time_spent, collectibles_collected]
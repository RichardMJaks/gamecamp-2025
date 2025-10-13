extends HBoxContainer

func initialize(level_name: String, time: float, collectibles: int) -> void:
	%LevelTitle.text = level_name 
	%Time.text = GlobalVars.float_to_time(time) 
	%CollectibleCount.text = str(collectibles)

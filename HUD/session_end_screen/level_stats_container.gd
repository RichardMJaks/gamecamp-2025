extends HBoxContainer

func initialize(level_name: String, time: float, collectibles: int) -> void:
	%LevelTitle.text = level_name 
	%Time.text = "%02d:%02d.%03d" % [time / 60, floori(time), (time - floori(time)) * 1000]
	%CollectibleCount.text = str(collectibles)

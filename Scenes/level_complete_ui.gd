extends PanelContainer

@onready var total_collectibles_label: Label = %TotalCollectibles
@onready var total_time_label: Label = %TotalTime

func show_ui(total_collectibles: int, total_time: float) -> void:
	visible = true
	total_collectibles_label.text = str(total_collectibles)
	total_time_label.text = "%02d:%02d.%03d" % [total_time / 60, floori(total_time), (total_time - floori(total_time)) * 1000]

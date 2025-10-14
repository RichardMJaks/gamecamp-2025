extends PanelContainer

@onready var total_collectibles_label: Label = %TotalCollectibles
@onready var total_time_label: Label = %TotalTime
@onready var container_revealer: AnimationPlayer = %ContainerRevealer

func show_ui(total_collectibles: int, total_time: float) -> void:
	visible = true
	total_collectibles_label.text = str(total_collectibles)
	total_time_label.text = GlobalVars.float_to_time(total_time) 
	container_revealer.play("reveal")


func _on_continue_button_pressed() -> void:
	SignalBus.start_fade_out.emit()
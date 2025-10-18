extends PanelContainer

@onready var total_collectibles_label: Label = %TotalCollectibles
@onready var total_time_label: Label = %TotalTime
@onready var container_revealer: AnimationPlayer = %ContainerRevealer
@onready var continue_button = %ContinueButton
var showing: bool = false

func _input(event: InputEvent) -> void:
	if not showing:
		return

	if event.is_action_released(&"ui_accept"):
		_continue()

	if continue_button.has_focus():
		return

	# Check for any directional input before grabbing focus to button
	if (event.is_action(&"ui_up") or event.is_action(&"ui_down")):
		continue_button.grab_focus()


func _ready() -> void:
	if not GameController.mobile and not OS.has_feature("expo"):
		%ContinueButton.queue_free()
	else:
		%ContinueButton.visible = true
		%NextLevelTexture.visible = false

func show_ui(total_collectibles: int, total_time: float) -> void:
	visible = true
	showing = true
	total_collectibles_label.text = str(total_collectibles)
	total_time_label.text = GlobalVars.float_to_time(total_time) 
	container_revealer.play("reveal")


func _on_continue_button_pressed() -> void:
	_continue()


func _continue() -> void:
	SignalBus.start_fade_out.emit()
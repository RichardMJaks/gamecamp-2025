extends ColorRect
class_name Fader

signal fade_in_finished()
signal fade_out_finished()
var transition_time: float = 1

@export var fade_in_color: Color
@export var fade_out_color: Color


func _ready() -> void:
	SignalBus.start_fade_out.connect(_fade_out)
	visible = true
	_fade_in()

func _fade_in() -> void:
	material.set_shader_parameter("time", 1)
	material.set_shader_parameter("reverse", false)
	var tween = create_tween()
	tween.tween_method(set_param, 1.0, 0.0, transition_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(fade_in_finished.emit)

func _fade_out() -> void:
	material.set_shader_parameter("time", 0)
	material.set_shader_parameter("reverse", true)
	var tween = create_tween()
	tween.tween_method(set_param, 0.0, 1.0, transition_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(_post_fade_out_delay.bind(fade_out_finished.emit))

func _post_fade_out_delay(callable: Callable) -> void:
	get_tree().create_timer(1).timeout.connect(callable)


func set_param(value: float) -> void:
	material.set_shader_parameter("time", value)

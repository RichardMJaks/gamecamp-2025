extends ColorRect

signal fade_in_finished()
signal fade_out_finished()
var transition_time: float = 0.3

func _ready() -> void:
	visible = true
	_fade_in()

func _fade_in() -> void:
	print("fading in")
	material.set_shader_parameter("time", 1)
	var tween = create_tween()
	tween.tween_method(set_param, 1.0, 0.0, transition_time)
	tween.tween_callback(fade_in_finished.emit)

func _fade_out() -> void:
	material.set_shader_parameter("time", 0)
	var tween = create_tween()
	tween.tween_method(set_param, 0.0, 1.0, transition_time)
	tween.tween_callback(fade_out_finished.emit)

func set_param(value: float) -> void:
	material.set_shader_parameter("time", value)

func _process(delta: float) -> void:
	print(material.get_shader_parameter("time"))
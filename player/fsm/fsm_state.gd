extends Node
class_name FSMState

@warning_ignore("unused_signal")
signal change_state(new_state: FSMState)

func enter() -> void:
	pass

func exit() -> void:
	pass

func __process(_delta: float) -> void:
	pass

func __physics_process(_delta: float) -> void:
	pass

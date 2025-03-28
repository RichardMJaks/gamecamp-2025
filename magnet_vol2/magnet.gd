extends Area2D
class_name Magnet

@warning_ignore("int_as_enum_without_cast")
@export var pole: GlobalVars.POLE = 0

func attraction_action() -> void:
	pass

func detraction_action() -> void:
	pass

func switch_poles() -> void:
	@warning_ignore("int_as_enum_without_cast")
	pole = 1 - pole # Switches pole

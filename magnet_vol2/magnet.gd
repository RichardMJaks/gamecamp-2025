extends Area2D
class_name Magnet

# Pole type (North or South)
@export var pole: GlobalVars.POLE = GlobalVars.POLE.NORTH:
	set(value):
		pole_changed.emit()
		pole = value
@warning_ignore("unused_signal")
signal pole_changed

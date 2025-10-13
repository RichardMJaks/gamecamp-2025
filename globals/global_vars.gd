extends Node

# Standard Unit
var su: float = 16
enum POLE {SOUTH, NORTH}

func float_to_time(time: float) -> String:
	var minutes = floori(time / 60)
	var seconds = floori(time - minutes * 60)
	var milliseconds = (time - floori(time)) * 1000
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]
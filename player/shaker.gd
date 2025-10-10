extends Camera2D

var shaking: bool = false
var strength: float = 0
var strength_multiplier: float = 0
var initial_strength = 0
var duration: float = 0
var t: float = 0

signal shake_completed

func _process(delta: float) -> void:
	if t >= 1:
		if shaking:
			shake_completed.emit()
			
		offset = Vector2.ZERO
		shaking = false
		initial_strength = 0
	
	if not shaking:
		return
	
	var dir = Vector2.from_angle(randf() * 10)
	offset = (dir * strength).floor()
	
	t += delta * (1 / duration)
	var ease_in = func(x): return 2 * x * x * x
	strength = lerpf(strength, initial_strength * strength_multiplier, ease_in.call(t))
	
@warning_ignore("shadowed_variable")
func shake(strength : float, duration: float, final_strength_multiplier: float = 0) -> void:
	self.strength = strength
	self.duration = duration
	shaking = true
	t = 0
	initial_strength = strength
	strength_multiplier = final_strength_multiplier
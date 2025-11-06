extends Camera2D

@export var offset_clamp: float = 32

var shaking: bool = false
var strength: float = 0
var strength_multiplier: float = 0
var initial_strength = 0
var duration: float = 0
var t: float = 0

var player: Player = null


signal shake_completed

func _process(delta: float) -> void:
	if not shaking:
		clamp_offset()
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

@warning_ignore("unused_parameter")
func lock_to_radial_magnet(magnet: RadialMagnet) -> void:
	set_position_smoothing_speed(2)
	#player.unset_camera() 
	#global_position = magnet.global_position
	pass

func clamp_offset() -> void:
	offset = Vector2(
		clampf(offset.x, -offset_clamp, offset_clamp),
		clampf(offset.y, -offset_clamp, offset_clamp)
	)

func lock_to_player() -> void:
	set_position_smoothing_speed(8)
	#player.set_camera(self)
	pass

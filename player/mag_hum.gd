extends AudioStreamPlayer

@onready var player: Player = owner
@export var fade_in: float = 0.2
var fade_delta: float = 0
@export var fade_out: float = 0.05

@export var low_pitch: float = 0.8
@export var high_pitch: float = 1
@export var low_volume: float = -5
@export var high_volume: float = 0

func _physics_process(delta: float) -> void:
	if player.current_magnet:
		if not playing:
			play()
		_fade_in(delta)
	else:
		_fade_out(delta)

func _fade_in(delta) -> void:
	if fade_delta < 1:
		fade_delta += delta / fade_in
	else:
		fade_delta = 1
	volume_db = lerpf(low_volume, high_volume, fade_delta)
	pitch_scale = lerpf(low_pitch, high_pitch, fade_delta)

func _fade_out(delta) -> void:
	if fade_delta > 0:
		fade_delta -= delta / fade_out
	else:
		fade_delta = 0
		#playing = false
	volume_db = lerpf(low_volume, high_volume, fade_delta)
	pitch_scale = lerpf(low_pitch, high_pitch, fade_delta)
	
	 
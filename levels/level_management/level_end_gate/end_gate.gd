extends Area2D

@export var camera: Camera2D
@export var anim_player: AnimationPlayer

@export var player: Player = null

func _hide_player() -> void:
	if player:
		player.visible = false


func _on_player_entered_end_gate(body: Node2D) -> void:
	if not body is Player:
		return
	
	_stop_timing()

	player = body
	player.set_controlled()
	_tween_player_to_end_position()

	_shake_camera()
	camera.shake_completed.connect(_on_end_gate_animation_finished)

	anim_player.play("end_gate")


func _stop_timing() -> void:
	SignalBus.timing_stopped.emit()


func _tween_player_to_end_position() -> void:
	var end_position = _get_player_end_position()
	var tween = player.create_tween()
	tween.tween_property(player, ^"global_position", end_position, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _big_camera_shake() -> void:
	camera.shake(20, 2)

func _get_player_end_position() -> Vector2:
	return $PlayerFinalPosition.global_position

func _shake_camera() -> void:
	camera.shake(0.1, 3, 60)

# This will be called by Close particles finishing
func _on_end_gate_animation_finished() -> void:
	SignalBus.level_completed.emit()	

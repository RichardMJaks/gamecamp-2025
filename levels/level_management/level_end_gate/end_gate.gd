extends Area2D

@export var camera: Camera2D
@export var anim_player: AnimationPlayer


signal level_completed
@export var player: Player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_completed.connect(GameController.complete_level)


func _hide_player() -> void:
	if player:
		player.visible = false

func _on_player_entered_end_gate(body: Node2D) -> void:
	if not body is Player:
		return
	player = body
	var end_position = _get_player_end_position()
	_tween_player_to_end_position(end_position)
	player.set_controlled()
	camera.shake_completed.connect(_on_end_gate_animation_finished)
	anim_player.play("end_gate")

func _tween_player_to_end_position(end_position: Vector2) -> void:
	var tween = player.create_tween()
	tween.tween_property(player, ^"global_position", end_position, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_shake_camera()

func _big_camera_shake() -> void:
	camera.shake(20, 2)

func _get_player_end_position() -> Vector2:
	return $PlayerFinalPosition.global_position

func _shake_camera() -> void:
	camera.shake(0.1, 3, 60)

# This will be called by Close particles finishing
func _on_end_gate_animation_finished() -> void:
	level_completed.emit()

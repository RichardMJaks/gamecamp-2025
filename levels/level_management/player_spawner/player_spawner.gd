extends AnimatedSprite2D

@export var player_packedscene: PackedScene
@export var animation_player: AnimationPlayer
@export var scene_camera: Camera2D

var starting_pole: GlobalVars.POLE = GlobalVars.POLE.NORTH

@onready var player_spawn_position: Vector2 = $PlayerSpawnPosition.global_position
@onready var current_scene: Node = get_tree().current_scene


func spawn_player() -> void:
	_play_animation()


# Called by animation_finished signal of AnimationPlayer
func _add_player_to_scene() -> void:
	var player: Player = player_packedscene.instantiate()

	player.current_pole = starting_pole
	player.global_position = player_spawn_position

	current_scene.add_child(player)
	player.set_camera(scene_camera)
	scene_camera.shake(5, 0.5)


func _play_animation() -> void:
	animation_player.play("spawn_player")


# Called from animationplayer
func _start_timing() -> void:
	SignalBus.timing_started.emit()

extends FSMState

@onready var player: Player = owner
@export var move_state: FSMState
@export var timer: Timer
@export var afterimage_timer: Timer
@export var launch_force: float = 20
@export var whoosh: AudioStreamPlayer
@export var launch_particles: GPUParticles2D
@export var camera: Camera2D
@export var shake_intensity: float
@export var shake_time: float
@export var floor_launch_particles: PackedScene
@export var sprite: AnimatedSprite2D

var dir: Vector2 = Vector2.ZERO


func _ready() -> void:
	timer.timeout.connect(
		afterimage_timer.stop
	)
	afterimage_timer.timeout.connect(_create_afterimage)


func enter() -> void:
	_launch()
	timer.start()
	afterimage_timer.start()
	change_state.emit(move_state)


func _launch() -> void:
	_launch_player()
	_play_effects()


func _create_afterimage() -> void:
	var afterimage = Sprite2D.new()
	afterimage.texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame) 
	get_tree().current_scene.add_child(afterimage)
	afterimage.global_position = player.global_position
	afterimage.rotation = sprite.rotation
	afterimage.modulate = afterimage.modulate.darkened(0.3)
	var afterimage_tweener = afterimage.create_tween()
	afterimage_tweener.tween_property(afterimage, ^"modulate:a", 0, 0.3)
	afterimage_tweener.tween_callback(afterimage.queue_free)



func _emit_floor_launch_particles() -> void:
	var flp = floor_launch_particles.instantiate()
	get_tree().current_scene.add_child(flp)
	flp.global_position = player.global_position
	flp.rotation = player.up_direction.angle() + PI / 2


func _emit_launch_particles() -> void:
	launch_particles.emitting = false
	launch_particles.emitting = true


func _launch_player() -> void:
	dir = player.current_magnet.magnet_gravity_direction
	player.velocity = launch_force * GlobalVars.su * dir


func _play_effects() -> void:
	_emit_floor_launch_particles()
	_emit_launch_particles()
	camera.shake(shake_intensity, shake_time)
	whoosh.play()




func _on_floor_collision(_body:Node2D) -> void:
	timer.stop()
	afterimage_timer.stop()
	change_state.emit(move_state)
	player.velocity = player.velocity.normalized() * player.speed

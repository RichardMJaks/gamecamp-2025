extends Node

@export var timer: Timer
@export var afterimage_timer: Timer
@export var sprite: AnimatedSprite2D
@onready var player: Player = owner

func _ready() -> void:
	timer.timeout.connect(
		afterimage_timer.stop
	)
	afterimage_timer.timeout.connect(_create_afterimage)


func create_afterimages() -> void:
	timer.start()
	afterimage_timer.start()


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

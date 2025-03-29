extends Area2D

@export var collectible_sprite : Sprite2D
@export var collectible_particles : CPUParticles2D

signal collected

func _ready():
	add_to_group("collectibles")

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			collect()
			break
			
func collect():
		# Get game controller and update count
		var game_controller = get_tree().current_scene.get_node("GameController")
		if game_controller:
			game_controller.collect_collectible()
		
		emit_signal("collected")
		
		# Remove collectable
		queue_free()

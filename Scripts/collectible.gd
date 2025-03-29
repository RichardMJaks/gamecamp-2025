extends Area2D

@export var collectible_sprite : Sprite2D
@export var collectible_collision : CollisionShape2D
@export var collectible_particles : CPUParticles2D

signal collected
var is_collected = false

func _ready():
	add_to_group("collectibles")

func _physics_process(_delta):
	if not is_collected:
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				collect()
				break
			
func collect():
	is_collected = true
	
	# Get game controller and update count
	GameController.collect_collectible()
	
	emit_signal("collected")
	
	# Play particle effect if available
	if collectible_particles:
		collectible_particles.emitting = true
	
	# Hide visuals and disable collision instead of deleting
	if collectible_sprite:
		collectible_sprite.visible = false
	if collectible_collision:
		collectible_collision.disabled = true

func reset():
	# Only reset if it was previously collected
	if is_collected:
		is_collected = false
		
		# Show visuals and enable collision
		if collectible_sprite:
			collectible_sprite.visible = true
		if collectible_collision:
			collectible_collision.disabled = false
		
		# Stop particles if they were playing
		if collectible_particles:
			collectible_particles.emitting = false

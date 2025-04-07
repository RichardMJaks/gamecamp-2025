extends Node2D
@export var next_scene: PackedScene

@export var loadable_shaders: Array[PackedScene]
@export var loadable_particle_processors: Array[ParticleProcessMaterial]
var total_loaded: int = 0
@onready var total_size: int = loadable_shaders.size() + loadable_particle_processors.size()

func _process(_delta: float) -> void:
	if loadable_shaders.size() > 0:
		load_shader(loadable_shaders.pop_back())
		total_loaded += 1
		return
	if loadable_particle_processors.size() > 0:
		load_ppm(loadable_particle_processors.pop_back())
		total_loaded += 1
		return
	GameController.current_level_type = GameController.LEVEL_TYPE.GAME
	get_tree().change_scene_to_packed(next_scene)

func load_ppm(ppm: ParticleProcessMaterial) -> void:
	var gpup2d = GPUParticles2D.new()
	gpup2d.process_material = ppm
	add_child(gpup2d)

func load_shader(ps: PackedScene) -> void:
	var shader = ps.instantiate()
	add_child(shader)
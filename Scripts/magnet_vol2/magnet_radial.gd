extends Magnet
class_name RadialMagnet

@export var hook_range: float = 300.0
@export var orbital_radius: float = 80.0
@export var orbital_speed: float = 250.0

var potential_target: Player = null
var line: Line2D

func _ready() -> void:
	super._ready()
	
	# Create the hook line
	line = Line2D.new()
	line.width = 3.0
	line.default_color = Color(0.2, 0.6, 1.0, 0.8)
	line.points = [Vector2.ZERO, Vector2.ZERO]  # Initially empty line
	line.visible = false
	
	# We'll try to use a simple material first instead of shader to avoid potential issues
	line.default_color = Color(0.2, 0.6, 1.0, 0.8)
	
	# Try to load the shader if it exists
	if ResourceLoader.exists("res://shaders/magnet_hook_line.gdshader"):
		var shader_material = ShaderMaterial.new()
		var shader = load("res://shaders/magnet_hook_line.gdshader")
		shader_material.shader = shader
		line.material = shader_material
		print("Loaded shader for magnet line")
	else:
		print("Shader not found, using default line")
		
	add_child(line)
	print("Radial magnet initialized with hook line")

func _process(_delta: float) -> void:
	# Update the hook line if there's a potential target
	if potential_target != null:
		var distance = global_position.distance_to(potential_target.global_position)
		
		if distance <= hook_range:
			# Show line to player when in hook range
			line.visible = true
			line.points[0] = Vector2.ZERO  # Local origin of the magnet
			line.points[1] = to_local(potential_target.global_position)  # Convert player position to local
			
			# Adjust line color based on polarity match
			var player_pole = potential_target.current_pole
			var polarity_match = (player_pole != pole)  # Opposite poles attract
			
			# Update line color based on polarity
			if polarity_match:
				line.default_color = Color(0.2, 0.6, 1.0, 0.8)  # Blue for attraction
			else:
				line.default_color = Color(1.0, 0.3, 0.2, 0.8)  # Red for repulsion
				
			# If we have shader material, update it too
			if line.material is ShaderMaterial:
				var shader_mat = line.material as ShaderMaterial
				if shader_mat:
					var color = Color(1.0, 0.3, 0.2, 0.8)
					if polarity_match:
						color = Color(0.2, 0.6, 1.0, 0.8)
						
					shader_mat.set_shader_parameter("line_color", color)
		else:
			line.visible = false
	else:
		line.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player = body as Player
		
		# Track player for hook line visualization
		potential_target = player
		print("Player entered radial magnet range")
		
		# Add to magnets array
		super._on_body_entered(body)
		
		var state_machine = player.get_node("MovementStateMachine")
		if state_machine == null:
			print("State machine not found on player")
			return
			
		# Only transition to radial magnet state if player isn't in static velocity state
		if state_machine.current_state.state_name != "StaticVelocity":
			# Only hook if within range and poles match our logic
			var distance = global_position.distance_to(player.global_position)
			var polarity_match = (player.current_pole != pole)  # Opposite poles attract
			
			print("Distance to player: ", distance, ", Hook range: ", hook_range)
			print("Player pole: ", player.current_pole, ", Magnet pole: ", pole, ", Poles attract: ", polarity_match)
			
			if distance <= hook_range and polarity_match:
				var radial_state = state_machine.states.get("MagnetRadial")
				if radial_state:
					print("Transitioning to MagnetRadial state")
					radial_state.current_magnet = self
					radial_state.orbital_radius = orbital_radius
					radial_state.orbital_speed = orbital_speed
					radial_state.hook_range = hook_range
					state_machine.change_state("MagnetRadial")
				else:
					print("MagnetRadial state not found in state machine")

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		print("Player exited radial magnet range")
		if potential_target == body:
			potential_target = null
		super._on_body_exited(body)

extends Area2D

var target_value := 0.0

func _on_slider_value_changed(value: float):
	set_strength(value)

# expects -1 to 1
func set_strength(s : float) -> void:
	var normal = (s + 1) / 2
	var divisor = 3
	var hue = Vector2(normal/divisor, normal/divisor)

	$Flames.process_material.hue_variation = hue
	
	$Flames.process_material.set_param(15, Vector2(30 * s, 30 * s))
	
	#var offset = 50
	#$Flames.process_material.emission_shape_offset = Vector3(0, s * offset - offset, 0)
	
	var rad = clampf((100 * -s), 50, 100)
	$Flames.process_material.emission_ring_inner_radius = rad
	$Flames.process_material.emission_ring_radius = rad * 0.8
	

func _ready():
	var slider = $VSlider
	slider.connect("value_changed", _on_slider_value_changed)
	slider.value = 0

func _process(_delta: float) -> void:
	pass

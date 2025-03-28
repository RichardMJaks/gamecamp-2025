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
	$Flames.process_material.gravity = Vector3(0, -s * 300, 0)
	
	var offset = 50
	$Flames.process_material.emission_shape_offset = Vector3(0, s * offset - offset, 0)
	

func _ready():
	var slider = $VSlider
	slider.connect("value_changed", _on_slider_value_changed)
	slider.value = 0

func _process(_delta: float) -> void:
	pass

extends Area2D

var force: Vector2

func _on_body_entered(_body):
	if _body is CharacterBody2D:
		_body.enter_ff(force)

func _on_body_exited(_body):
	if _body is CharacterBody2D:
		_body.exit_ff(force)

func _ready():
	collision_layer = 1
	collision_mask = 1
	
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

extends Area2D

#var force: Vector2

var strength: float
var shape: CollisionShape2D

func _on_body_entered(_body):
	if _body is CharacterBody2D:
		_body.enter_ff(self)

func _on_body_exited(_body):
	if _body is CharacterBody2D:
		_body.exit_ff(self)

func _ready():
	collision_layer = 1
	collision_mask = 1
	
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

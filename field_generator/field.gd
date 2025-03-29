extends Area2D

var force: Vector2


func _ready():
	collision_layer = 1
	#collision_mask = 1
	
	connect("_body_entered", _on_body_entered)
	connect("_body_exited", _on_body_exited)

func _on_body_entered(body):
	print("entered:", position, "with force", force)

func _on_body_exited(body):
	print("exited:", position, "with force", force)

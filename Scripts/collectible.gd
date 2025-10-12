extends Area2D

@onready var anim_player = %AnimationPlayer

func _ready():
	add_to_group("collectibles")
	body_entered.connect(collect)

			
func collect(body: Node2D):
	if body is Player:
		anim_player.play("collected")
		SignalBus.collectible_collected.emit()

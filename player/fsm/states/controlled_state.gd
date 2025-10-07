extends FSMState

@onready var player: Player = owner

func enter() -> void:
    player.velocity = Vector2.ZERO
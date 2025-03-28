extends Node2D
class_name Magnet

@onready var su = GlobalVars.su
@export var pole: GlobalVars.POLE = GlobalVars.POLE.NORTH
@export var radius: float = 1
@export var strength: float = 1
@onready var effect_range: Area2D = %MagnetRange

func _process(_delta: float) -> void:
    # Sets correct range
    effect_range.get_child(0).shape.radius = radius * su


func _on_range_entered(area:Area2D) -> void:
    var a_owner = area.owner
    if not a_owner is Player:
        return

    a_owner.magnets.append(self)


func _on_range_exited(area:Area2D) -> void:
    var a_owner = area.owner
    if not a_owner is Player:
        return
    a_owner.magnets.erase(self)
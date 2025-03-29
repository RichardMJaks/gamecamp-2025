extends Node
class_name PlayerMovementState

# References to required components
var player: CharacterBody2D
var state_machine: PlayerMovementStateMachine

# State identifier
var state_name: String = ""

func _ready() -> void:
	if player == null:
		player = get_parent().get_parent() as Player

# Virtual methods to be overridden by specific states
func enter() -> void:
	pass

func exit() -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

# Helper methods for common movement patterns
func apply_gravity(delta: float) -> void:
	if player.gravity_direction.x == 0:
		if not player.is_on_floor():
			player.velocity.y += player.get_gravity().y * delta * player.gravity_direction.y
	else:
		if not player.is_on_floor():
			player.velocity.x += player.get_gravity().y * delta * player.gravity_direction.x

func handle_jump() -> void:
	if player.gravity_direction.x == 0:
		if Input.is_action_just_pressed(&"m_jump") and player.is_on_floor():
			player.velocity.y -= player._get_jump_height(player.jump_height) * player.gravity_direction.y
	else:
		if Input.is_action_just_pressed(&"m_jump") and player.is_on_floor():
			player.velocity.x -= player._get_jump_height(player.jump_height) * player.gravity_direction.x

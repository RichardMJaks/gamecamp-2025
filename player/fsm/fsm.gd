extends Node
class_name FSM

var states: Dictionary[String, FSMState] = {}

@export var starting_state: FSMState
var current_state: FSMState

func _ready() -> void:
	for child: FSMState in get_children():
		states[child.name] = child
		child.change_state.connect(_change_to_state)
	
	if starting_state:
		current_state = starting_state
		current_state.enter()

func _process(delta: float) -> void:
	current_state.__process(delta)

func _physics_process(delta: float) -> void:
	current_state.__physics_process(delta)


func _change_to_state(new_state: FSMState) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

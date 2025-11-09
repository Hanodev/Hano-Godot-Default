class_name StateMachine
extends Node

signal state_changed(state: StringName)
@export var states: Array[State]
var current_state: State

func _ready() -> void:
	for state in states:
		state.entity = get_parent()
		state.change_state.connect(_on_change_state)
	current_state = states[0]

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)

func _on_change_state(new_state: String) -> void:
	for state: State in states:
		if state.state_name == new_state:
			current_state = state
			state_changed.emit(new_state)
			break

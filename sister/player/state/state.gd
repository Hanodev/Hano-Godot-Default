class_name State
extends Resource

signal change_state(new_state: State)

var entity: CharacterBody3D
var state_name: StringName
func physics_process(delta: float) -> void:
	pass

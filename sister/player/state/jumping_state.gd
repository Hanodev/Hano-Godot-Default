class_name JumpingState
extends State
@export var jump_strength:= 5.0
func _init() -> void:
	state_name = &"JumpingState"

func physics_process(delta: float) -> void:
	entity.velocity.y += jump_strength
	change_state.emit("FallingState")

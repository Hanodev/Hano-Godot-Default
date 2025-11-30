class_name JumpingState
extends State

func _init() -> void:
	state_name = &"JumpingState"

func physics_process(delta: float) -> void:
	entity.velocity.y += 18.0
	change_state.emit("FallingState")

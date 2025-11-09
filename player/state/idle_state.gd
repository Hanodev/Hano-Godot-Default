class_name IdleState
extends State

func _init() -> void:
	state_name = &"IdleState"
func physics_process(delta: float) -> void:
	entity.velocity.x = lerp(entity.velocity.x,0.0,5.0 * delta)
	entity.velocity.z = lerp(entity.velocity.z,0.0,5.0 * delta)

	if not entity.is_on_floor():
		change_state.emit("FallingState")
		return

	if Input.is_action_just_pressed(&"Jump"):
		change_state.emit("JumpingState")

	if Input.get_vector(&"Left",&"Right",&"Forward",&"Backward"):
		change_state.emit("WalkingState")
		return

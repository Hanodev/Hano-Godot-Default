class_name WalkingState
extends State
@export var speed:= 15.0
func _init() -> void:
	state_name = &"WalkingState"
func physics_process(delta: float) -> void:
	var input_direction := Input.get_vector(&"Left",&"Right",&"Forward",&"Backward")
	var direction = entity.global_transform.basis * Vector3(input_direction.x,0.0,input_direction.y).normalized()

	entity.velocity.x = lerp(entity.velocity.x,direction.x * speed,5.0 * delta)
	entity.velocity.z = lerp(entity.velocity.z,direction.z * speed,5.0 * delta)

	if Input.is_action_just_pressed(&"Jump"):
		change_state.emit("JumpingState")

	if not input_direction:
		change_state.emit("IdleState")

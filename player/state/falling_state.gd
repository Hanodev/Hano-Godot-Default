class_name FallingState
extends State

var speed:= 10.0
func _init() -> void:
	state_name = &"FallingState"

func physics_process(delta: float) -> void:
	var input_direction := Input.get_vector(&"Left",&"Right",&"Forward",&"Backward")
	var direction = entity.global_transform.basis * Vector3(input_direction.x,0.0,input_direction.y).normalized()

	entity.velocity.x = lerp(entity.velocity.x,direction.x * speed,1.0 * delta)
	entity.velocity.z = lerp(entity.velocity.z,direction.z * speed,1.0 * delta)

	entity.velocity.y -= 50.0 * delta

	if entity.is_on_floor():
		change_state.emit("IdleState")

extends AnimationPlayer


func _on_state_machine_state_changed(state: StringName) -> void:
	match state:
		&"IdleState": play(&"Sword_Idle")
		&"WalkingState": play(&"Sprint")
		&"FallingState": play(&"Jump")
		&"JumpingState": play(&"Jump")
		_: play(&"Idle")

func function():
	pass

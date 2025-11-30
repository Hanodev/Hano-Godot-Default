class_name Interactor
extends RayCast3D


var collider: Interactable

func _input(event: InputEvent) -> void:
	if not is_colliding(): return
	if Input.is_action_just_pressed("Interact"):
		if collider is Interactable:
			collider._interact()

func _process(delta: float) -> void:
	if is_colliding():
		_check_collider()


	elif not is_colliding():

		if collider:
			collider.unhover()


		collider = null

func _check_collider() -> void:
	var new_collider = get_collider()

	if new_collider == collider:
		return

	if new_collider is Interactable:
		if collider:
			collider.unhover()

		collider = new_collider
		collider.hover()

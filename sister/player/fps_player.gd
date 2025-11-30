extends CharacterBody3D


@onready var camera_3d: Camera3D = %Camera3D
@onready var camera_holder: Node3D = $CameraPivot/CameraHolder

@export var jump_strength:= 20.0
@export var gravity:= 22.0
@export var speed:= 8.0

const mouse_sensitivity:= 0.05



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		camera_holder.rotation.x += deg_to_rad(-event.relative.y) * mouse_sensitivity
		rotation.y += deg_to_rad(-event.relative.x) * mouse_sensitivity


func _physics_process(delta: float) -> void:
	move_and_slide()

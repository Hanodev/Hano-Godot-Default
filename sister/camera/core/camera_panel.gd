extends Control

const CAMERA_BUTTON = preload("uid://b7x6n0ik4y5o2")
@onready var camera_container: VBoxContainer = %CameraContainer

@export var camera_system: CameraSystem

var original_camera: Camera3D


func _ready() -> void:
	await get_tree().process_frame
	original_camera = get_viewport().get_camera_3d()

func _create_cameras(camera: Array[Camera3D]) -> void:
	for cam: Camera3D in camera:
		var button: Button = CAMERA_BUTTON.instantiate()
		camera_container.add_child(button)
		button.pressed.connect(set_cam.bind(cam))

func _exit() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_cam(original_camera)

func set_cam(cam: Camera3D) -> void:
	get_viewport().get_camera_3d().clear_current()
	cam.make_current()

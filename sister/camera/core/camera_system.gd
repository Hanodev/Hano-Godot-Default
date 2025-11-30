class_name CameraSystem
extends Node3D

signal cameras_loaded(cameras: Array[Camera3D])

var cameras: Array[Camera3D]
@onready var camera_panel: MarginContainer = $CameraPanel

func _ready() -> void:
	for c in get_children():
		if c is Camera3D:
			cameras.append(c)
	cameras_loaded.emit(cameras)
	camera_panel.hide()

func _open_panel() -> void:
	camera_panel.show()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _hide_panel() -> void:
	camera_panel.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

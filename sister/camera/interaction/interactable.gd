class_name Interactable
extends Area3D

signal interacted()
signal hovered()
signal unhovered()



func _ready() -> void:
	set_collision_layer_value(3,true)

func _interact() -> void:
	interacted.emit()

func hover() -> void:
	hovered.emit()

func unhover() -> void:
	unhovered.emit()

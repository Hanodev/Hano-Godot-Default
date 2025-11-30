class_name Interactable
extends Area3D

signal interacted

@export var cooldown_amt = 0.1
@export var delete_on_interact := false

var can_interact := true

func interact(player : CharacterBody3D):
	if !can_interact: return
	interacted.emit(player)
	
	can_interact = false
	if delete_on_interact: queue_free()
	
	await get_tree().create_timer(cooldown_amt).timeout
	can_interact = true

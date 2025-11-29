extends Node2D

class_name EntityState

var entity

func enter(prev_state: EntityState) -> void:
	pass

func exit(next_state: EntityState) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

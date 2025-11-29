extends Node2D

class_name PlayerState

var player

func enter(prev_state: PlayerState) -> void:
	pass

func exit(next_state: PlayerState) -> void:
	pass

func handle_input(event: InputEvent) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

extends Node2D

class_name Entity

@export var hitbox_height := 16.0
@export var hitbox_width := 23.0
@export var character_frames_res = "res://scenes/frames/seeker_frames.tscn"

@onready var hitbox := $Area2D/CollisionShape2D
@onready var player := get_tree().current_scene.get_node_or_null("Player") as Player

var frames = null

const SPEED = 200.0

func _process(delta: float) -> void:
	if player == null:
		return
		
	var target_pos = player.global_position
	var dir = target_pos - global_position
	
	global_position += dir.normalized() * SPEED * delta

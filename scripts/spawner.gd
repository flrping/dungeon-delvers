extends Node2D

class_name Spawner

@export var cooldown = 5.0
@export var amount_per_spawn = 3
@export var entity_limit = 15
@export var entity_frame_paths: Array[String] = []
@export var in_control = false

var entities: Array[Node2D] = []
var tracked_entites: Array[Node2D] = []
var timer = 0.0

signal on_spawn
signal on_capture

func _ready() -> void:
	for entity_frames_path in entity_frame_paths:
		var loaded_frames := load(entity_frames_path).instantiate() as Node2D
		var entity := preload("res://scenes/entity/entity.tscn").instantiate() as Entity
		entity.add_child(loaded_frames)
		entities.append(entity)
		print(entity)

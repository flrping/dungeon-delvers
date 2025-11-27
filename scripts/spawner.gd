extends Node2D

class_name Spawner

@export var cooldown = 5.0
@export var amount_per_spawn = 3
@export var entity_limit = 15
@export var entity_paths: Array[String] = ["res://scenes/entity/enemy/seeker.tscn"]
@export var in_control = false

var entities: Array[Node2D] = []
var tracked_entites: Array[Node2D] = []
var timer = 0.0

signal on_spawn
signal on_capture

func _ready() -> void:
	for entity_path in entity_paths:
		var loaded_entity := load(entity_path).instantiate() as Entity
		entities.append(loaded_entity)

extends Node2D

class_name Spawner

@export var cooldown = 5.0
@export var amount_per_spawn = 3
@export var entity_limit = 15
@export var enemy_entity_paths: Array[String] = ["res://scenes/entity/enemy/seeker_enemy.tscn"]
@export var ally_entity_paths: Array[String] = ["res://scenes/entity/ally/soldier_ally.tscn"]
@export var in_control = false

var enemy_entities: Array[Node2D] = []
var ally_entities: Array[Node2D] = []
var tracked_entites: Array[Node2D] = []
var timer = 0.0

func _init() -> void:
	for entity_path in enemy_entity_paths:
		var loaded_entity := load(entity_path).instantiate() as Entity
		enemy_entities.append(loaded_entity)
		
	for entity_path in ally_entity_paths:
		var loaded_entity := load(entity_path).instantiate() as Entity
		ally_entities.append(loaded_entity)

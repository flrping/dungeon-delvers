extends Node2D

class_name Spawner

@export var cooldown = 5.0
@export var amount_per_spawn = 3
@export var entity_limit = 15
@export var enemy_entity_paths: Array[String] = ["res://scenes/entity/enemy/seeker_enemy.tscn"]
@export var ally_entity_paths: Array[String] = ["res://scenes/entity/ally/soldier_ally.tscn"]
@export var in_control = false

@onready var area: CollisionShape2D = $Area2D/CollisionShape2D
@onready var color: ColorRect = $ColorRect

var capture_progress := 0.0
var enemy_entities: Array[PackedScene] = []
var ally_entities: Array[PackedScene] = []
var tracked_entites: Array[Entity] = []
var timer = 0.0

func _init() -> void:
	for entity_path in enemy_entity_paths:
		var packed := load(entity_path) as PackedScene
		enemy_entities.append(packed)
		
	for entity_path in ally_entity_paths:
		var packed := load(entity_path) as PackedScene
		ally_entities.append(packed)

func _process(delta: float) -> void:
	_attempt_spawn(delta)

func _attempt_spawn(delta) -> void:
	timer += delta
	if timer >= cooldown:
		timer = 0.0

		if amount_per_spawn + tracked_entites.size() > entity_limit:
			return

		var entities_spawned := []
		for i in range(amount_per_spawn):
			var copy: Node 
			if in_control:
				copy = ally_entities[randi_range(0, ally_entities.size() - 1)].instantiate()
			else:
				copy = enemy_entities[randi_range(0, enemy_entities.size() - 1)].instantiate()
				
			var rect: Rect2 = area.shape.get_rect()
			var spawn_x: float = randf_range(rect.position.x, rect.position.x + rect.size.x)
			var spawn_y: float = randf_range(rect.position.y, rect.position.y + rect.size.y)
			var rand_point: Vector2 = global_position + Vector2(spawn_x, spawn_y)
			copy.position = rand_point
			copy.assigned_area = area
			
			get_tree().current_scene.add_child(copy)
			entities_spawned.append({
				"entity": copy,
				"spawn_point": rand_point,
				"belongs_to_room": self
			})
			tracked_entites.append(copy)
			Bus.emit_signal("on_entity_spawn", copy)

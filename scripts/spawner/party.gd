extends Node2D

class_name Party

@export var entity_limit = 15
@export var enemy_entity_paths: Array[String] = [
	"res://scenes/entity/enemy/seeker_enemy.tscn", 
	"res://scenes/entity/enemy/slime_enemy.tscn",
	"res://scenes/entity/enemy/skeleton_enemy.tscn",
	"res://scenes/entity/enemy/goblin_enemy.tscn",
	"res://scenes/entity/enemy/seer_enemy.tscn"
]
@export var ally_entity_paths: Array[String] = ["res://scenes/entity/ally/" + Global.player_name.to_lower() + "_ally.tscn"]
@export var in_control = false

@export var has_captain = false
@export var kill_all_on_captain_death = true

@onready var area: CollisionShape2D = $Area2D/CollisionShape2D

var captain: Entity
var is_captain_dead = false
var enemy_entities: Array[PackedScene] = []
var ally_entities: Array[PackedScene] = []
var tracked_entites: Array[Entity] = []

func _ready() -> void:
	for entity_path in enemy_entity_paths:
		var packed := load(entity_path) as PackedScene
		enemy_entities.append(packed)
		
	for entity_path in ally_entity_paths:
		var packed := load(entity_path) as PackedScene
		ally_entities.append(packed)
		
	Bus.connect("on_enemy_death", _on_enemy_death)
	Bus.connect("on_ally_death", _on_ally_death)
	
	call_deferred("_attempt_spawn")
	if has_captain: call_deferred("_spawn_captain")

func _attempt_spawn() -> void:
	var entities_spawned := []
	for i in range(entity_limit):
		var copy: Entity
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
		copy._set_state("wander")
		
		entities_spawned.append({
			"entity": copy,
			"spawn_point": rand_point,
			"belongs_to_room": self
		})
		tracked_entites.append(copy)
		Bus.emit_signal("on_entity_spawn", copy)
		
func _spawn_captain() -> void:
	is_captain_dead = false
	if in_control:
		captain = ally_entities[randi_range(0, ally_entities.size() - 1)].instantiate()
	else:
		captain = enemy_entities[randi_range(0, enemy_entities.size() - 1)].instantiate()
			
	var rect: Rect2 = area.shape.get_rect()
	var spawn_x: float = randf_range(rect.position.x, rect.position.x + rect.size.x)
	var spawn_y: float = randf_range(rect.position.y, rect.position.y + rect.size.y)
	var rand_point: Vector2 = global_position + Vector2(spawn_x, spawn_y)
	captain.scale = Vector2(3, 3)
	captain.position = rand_point
	captain.assigned_area = area
	captain.job = "captain"
		
	get_tree().current_scene.add_child.call_deferred(captain)
	captain.call_deferred("_set_state", "wander")
	Bus.emit_signal("on_entity_spawn", captain)

	
func _on_enemy_death(entity: Entity, _source: Variant) -> void:
	if in_control:
		return
		
	if not tracked_entites.has(entity):
		return
		
	tracked_entites.erase(entity)
	
	if entity.job == "captain" and kill_all_on_captain_death:
		for tracked_entity in tracked_entites:
			tracked_entity.queue_free()
		tracked_entites.clear()
		Bus.emit_signal("on_party_kill", self)
	elif tracked_entites.is_empty():
		Bus.emit_signal("on_party_kill", self)

func _on_ally_death(entity: Entity, _source: Variant) -> void:
	if not in_control:
		return
		
	if not tracked_entites.has(entity):
		return
	
	if entity.job == "captain" and kill_all_on_captain_death:
		for tracked_entity in tracked_entites:
			tracked_entity.queue_free()
		tracked_entites.clear()
		Bus.emit_signal("on_party_kill", self)
	elif tracked_entites.is_empty():
		Bus.emit_signal("on_party_kill", self)

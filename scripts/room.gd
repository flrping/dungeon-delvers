extends "res://scripts/spawner.gd"

class_name Room

@onready var area = $Area2D/CollisionShape2D

var capture_progress := 0.0

func _process(delta: float) -> void:
	_attempt_spawn(delta)

func _attempt_spawn(delta):
	timer += delta
	if timer >= cooldown:
		timer = 0.0

		if amount_per_spawn + tracked_entites.size() >= entity_limit:
			return

		var entities_spawned := []
		for i in range(amount_per_spawn):
			var copy = entities[randi_range(0, entities.size() - 1)].duplicate()

       		var rect = area.shape.get_rect()
			var spawn_x = randi_range(rect.position.x, rect.position.x + rect.size.x)
			var spawn_y = randi_range(rect.position.y, rect.position.y + rect.size.y)
			var rand_point = global_position + Vector2(spawn_x, spawn_y)
			copy.position = rand_point

			get_tree().current_scene.add_child(copy)

			entities_spawned.append({
				"entity": copy,
				"spawn_point": rand_point,
				"belongs_to_room": self
			})
			
		on_spawn.emit(entities_spawned)

func _on_ally_kill():
	if not in_control:
		return

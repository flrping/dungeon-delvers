extends Spawner

class_name Room

@onready var area: CollisionShape2D = $Area2D/CollisionShape2D
@onready var color: ColorRect = $ColorRect

const ENEMY_COLOR: String = "#f1080032"
const ALLY_COLOR: String = "#3d86c785"

var capture_progress := 0.0

func _process(delta: float) -> void:
	_attempt_spawn(delta)

func _attempt_spawn(delta) -> void:
	timer += delta
	if timer >= cooldown:
		timer = 0.0

		if amount_per_spawn + tracked_entites.size() >= entity_limit:
			return

		var entities_spawned := []
		for i in range(amount_per_spawn):
			var copy: Node = entities[randi_range(0, entities.size() - 1)].duplicate()

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
			
		on_spawn.emit(entities_spawned)

func _on_enemy_kill() -> void:
	if in_control:
		return

func _on_ally_kill() -> void:
	if not in_control:
		return
		
func _on_capture(_source) -> void:
	if in_control:
		color.set_color(ALLY_COLOR)
	else:
		color.set_color(ENEMY_COLOR)

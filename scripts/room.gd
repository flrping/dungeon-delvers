extends "res://scripts/spawner.gd"

class_name Room

var capture_progress := 0.0

func _process(delta: float) -> void:
	_attempt_spawn(delta)

func _attempt_spawn(delta):
	timer += delta
	if timer >= cooldown:
		timer = 0.0
		print("spawn attempt")

		if amount_per_spawn + tracked_entites.size() >= entity_limit:
			print("spawn attempt failed")
			return
		
		print("spawn succeeded")
		print(entities.size())
		for i in range(amount_per_spawn):
			var copy = entities[randi_range(0, entities.size() - 1)].duplicate()
			get_tree().current_scene.add_child(copy)
			
		on_spawn.emit()

func _on_ally_kill():
	if not in_control:
		return

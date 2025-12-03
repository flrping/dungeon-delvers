extends EntityState

class_name EntityIdleState

func enter(_prev_state: EntityState) -> void:
	entity.idle_timer = 0.0
	entity.idle_time = randf_range(entity.min_idle_time, entity.max_idle_time)

func physics_update(delta: float) -> void:
	entity.velocity = Vector2.ZERO
	entity.idle_timer += delta
	if entity.idle_timer >= entity.idle_time:
		entity._set_state("wander")

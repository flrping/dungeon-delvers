extends EntityState

class_name EntityHuntState

func enter(prev_state: EntityState) -> void:
	pass
	
func exit(next_state: EntityState) -> void:
	pass
	
func physics_update(delta: float) -> void:
	if entity.target == null:
		entity.idle_timer = entity.idle_time
		entity._set_state("idle")
		return
	
	var target_pos: Vector2 = entity.target.global_position
	entity.last_known_target_pos = target_pos
	var dist: float = entity.global_position.distance_to(target_pos)
	
	if dist <= entity.ATTACK_DISTANCE:
		entity.velocity = Vector2.ZERO
	else:
		entity.navigation.target_position = target_pos
		
	var next_point: Vector2 = entity.navigation.get_next_path_position()
	var dir: Vector2 = next_point - entity.global_position
	entity.velocity = dir.normalized() * entity.speed
	entity.move_and_slide()

extends EntityState

class_name EntityHuntState

func physics_update(_delta: float) -> void:
	if entity.target == null:
		entity.idle_timer = entity.idle_time
		entity._set_state("idle")
		return
	
	var target_pos: Vector2 = entity.target.global_position
	entity.last_known_target_pos = target_pos
	var dist: float = entity.global_position.distance_to(target_pos)
	
	if dist <= entity.ATTACK_DISTANCE:
		entity.navigation.target_position = entity.global_position
	else:
		entity.navigation.target_position = target_pos
		
	var next_point: Vector2 = entity.navigation.get_next_path_position()
	var dir: Vector2 = next_point - entity.global_position
	entity.velocity = dir.normalized() * entity.speed
	
	var facing: Vector2 = entity.velocity.normalized()
	if abs(facing.x) > abs(facing.y):
		if facing.x < 0:
			entity.facing_direction = Vector2.LEFT
		else:
			entity.facing_direction = Vector2.RIGHT 
	else:
		if facing.y < 0:
			entity.facing_direction = Vector2.UP
		else:
			entity.facing_direction = Vector2.DOWN

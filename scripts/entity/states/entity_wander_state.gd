extends EntityState

class_name EntityWanderState

func enter(prev_state: EntityState) -> void:
	entity._set_new_random_target()

func physics_update(delta: float) -> void:
	if entity.navigation.is_navigation_finished():
		entity.idle_timer = 0.0
		entity._set_state("idle")
		return
		
	if not entity.navigation.is_target_reachable():
		print("Unreachable pos:", entity.navigation.target_position)
		entity._set_new_random_target()
		return
		
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
	
	entity.move_and_slide()

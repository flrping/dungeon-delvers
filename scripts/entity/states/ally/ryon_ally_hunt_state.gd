extends EntityState

class_name RyonAllyHuntState

func enter(_prev_state: EntityState) -> void:
	match entity.facing_direction:
		Vector2.UP:
			entity.frames.play("attack_up")
		Vector2.DOWN:
			entity.frames.play("attack_down")
		Vector2.LEFT:
			entity.frames.play("attack_side")
			entity.frames.flip_h = true
		Vector2.RIGHT:
			entity.frames.play("attack_side")
			entity.frames.flip_h = false
			
	entity.attack_timer = entity.attack_time
	
func physics_update(delta: float) -> void:
	if entity.target == null:
		entity.idle_timer = entity.idle_time
		entity._set_state("idle")
		return
	
	entity.attack_timer += delta
	
	var target_pos: Vector2 = entity.target.global_position
	entity.last_known_target_pos = target_pos
	var dist: float = entity.global_position.distance_to(target_pos)
	
	if dist <= entity.ATTACK_DISTANCE:
		entity.velocity = Vector2.ZERO
			
		entity.frames.play("attack_side")
		
		if entity.attack_timer >= entity.attack_time:
			entity.attack_timer = 0.0
			_spawn_projectile(target_pos)
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
	
	entity.move_and_slide()

func _spawn_projectile(target_pos):
	var dir: Vector2 = (target_pos - entity.global_position).normalized()
	var new_spell = entity.spell.instantiate()
	new_spell.global_position = entity.global_position
	new_spell.velocity = dir * 400
	
	entity.get_parent().add_child(new_spell)

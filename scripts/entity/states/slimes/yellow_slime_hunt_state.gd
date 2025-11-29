extends EntityState

class_name YellowSlimeHuntState

const TICK_TIME: float = 1.0

var move_wait_timer: float = 0.0
var jump_timer: float = 0.0
var tick_timer: float = 0.0
var is_jumping: bool = false
var is_ticking: bool = false

func enter(prev_state: EntityState) -> void:
	pass
	
func exit(next_state: EntityState) -> void:
	pass
	
func physics_update(delta: float) -> void:
	if entity.target == null:
		entity.idle_timer = entity.idle_time
		entity._set_state("idle")
		return
	
	move_wait_timer += delta
	
	if is_ticking:
		tick_timer += delta
		
		if tick_timer > TICK_TIME:
			entity.frames.play("yellow_explode")
			await entity.frames.animation_finished
			entity._take_damage(entity.max_health, Vector2.ZERO)
		return

	var target_pos: Vector2 = entity.target.global_position
	entity.last_known_target_pos = target_pos
	var dist: float = entity.global_position.distance_to(target_pos)
	
	if dist <= entity.ATTACK_DISTANCE:
		is_ticking = true
		entity.frames.play("yellow_tick")
	else:
		entity._set_target_within_bounds(target_pos)
		
	if is_jumping:
		jump_timer += delta
		
		if jump_timer >= entity.JUMP_DURATION:
			is_jumping = false
			jump_timer = 0.0
		return
	else:
		var next_point: Vector2 = entity.navigation.get_next_path_position()
		var dir: Vector2 = next_point - entity.global_position
		
		entity.velocity = dir.normalized() * entity.speed * 2
		is_jumping = true
		jump_timer = 0.0

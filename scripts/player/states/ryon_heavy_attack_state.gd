extends PlayerState

class_name RyonHeavyAttackState

func enter(_prev_state):
	player.velocity = player.velocity * 0.25
	var animation := "attack_down"
	match player.facing_direction:
		Vector2.LEFT, Vector2.RIGHT:
			animation = "attack_side"
		Vector2.UP:
			animation = "attack_up"
			
	player.frames.play(animation)
	_attack_process()

func _attack_process() -> void:
	await player.frames.animation_finished

	if player.has_spawned:
		_recover_trident()
	else:
		_spawn_trident()
	
	player._set_state("idle")

func _spawn_trident():
	var existing = player.get_parent().get_node_or_null("RyonTrident")
	if existing != null:
		return
		
	var dir := Vector2.ZERO
	match player.frames.animation:
		"attack_side":
			if player.frames.flip_h:
				dir = Vector2.LEFT
			else:
				dir = Vector2.RIGHT
		"attack_down":
			dir = Vector2.DOWN
		"attack_up":
			dir = Vector2.UP
		_:
			dir = Vector2.DOWN
			
	var new_trident = player.trident.instantiate()
	new_trident.name = "RyonTrident"
	new_trident.global_position = player.global_position
	new_trident.velocity = dir * 1200
	new_trident.player = player
	
	player.get_parent().add_child(new_trident)
	player.has_spawned = true

func _recover_trident():
	var _trident = player.get_parent().get_node_or_null("RyonTrident")
	if _trident:
		_trident.is_coming_home = true
	player.is_recovering = true

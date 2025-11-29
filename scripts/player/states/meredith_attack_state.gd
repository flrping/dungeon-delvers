extends PlayerState

class_name MeredithAttackState

func enter(_prev_state):
	var animation := "attack_down"
	
	var shape_to_enable: CollisionShape2D
	match player.facing_direction:
		Vector2.LEFT, Vector2.RIGHT:
			animation = "attack_side"
			if player.frames.flip_h:
				shape_to_enable = player.attack_hitbox_left.get_node("CollisionShape2D")
			else:
				shape_to_enable = player.attack_hitbox_right.get_node("CollisionShape2D")
			player.frames.flip_h = !player.frames.flip_h
		Vector2.UP:
			animation = "attack_up"
			shape_to_enable = player.attack_hitbox_up.get_node("CollisionShape2D")
		Vector2.DOWN:
			animation = "attack_down"
			shape_to_enable = player.attack_hitbox_down.get_node("CollisionShape2D")
			player.frames.offset.y = 8
	
	shape_to_enable.disabled = false
	player.frames.play(animation)
	_attack_process()

func _attack_process() -> void:
	await player.frames.animation_finished
	_disable_all_attack_shapes()
	player.frames.flip_h = !player.frames.flip_h
	player.frames.offset.y = 0
	player._set_state("idle")

func _disable_all_attack_shapes() -> void:
	player.attack_hitbox_up.get_node("CollisionShape2D").disabled = true
	player.attack_hitbox_down.get_node("CollisionShape2D").disabled = true
	player.attack_hitbox_left.get_node("CollisionShape2D").disabled = true
	player.attack_hitbox_right.get_node("CollisionShape2D").disabled = true

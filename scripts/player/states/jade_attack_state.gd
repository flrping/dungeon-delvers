extends PlayerState

class_name JadeAttackState

@onready var jade = preload("res://scenes/entity/projectile/jaded_projectile.tscn")

func enter(prev_state: PlayerState) -> void:
	player.velocity = player.velocity * 0.25
	var animation := "attack_down"
		
	var shape_to_enable: CollisionShape2D
	match player.facing_direction:
		Vector2.LEFT, Vector2.RIGHT:
			animation = "attack_side"
			if player.frames.flip_h:
				shape_to_enable = player.attack_hitbox_left.get_node("CollisionShape2D")
			else:
				shape_to_enable = player.attack_hitbox_right.get_node("CollisionShape2D")
		Vector2.UP:
			animation = "attack_up"
			shape_to_enable = player.attack_hitbox_up.get_node("CollisionShape2D")
		Vector2.DOWN:
			animation = "attack_down"
			shape_to_enable = player.attack_hitbox_down.get_node("CollisionShape2D")
			player.frames.offset.y = 8
	
	var new_jade = jade.instantiate()
	new_jade.position = player.position
	match player.facing_direction:
		Vector2.LEFT, Vector2.RIGHT:
			animation = "attack_side"
			if player.frames.flip_h:
				new_jade.velocity = Vector2.LEFT * 600
			else:
				new_jade.velocity = Vector2.RIGHT * 600
		Vector2.UP:
			animation = "attack_up"
			new_jade.velocity = Vector2.UP * 600
		Vector2.DOWN:
			animation = "attack_down"
			new_jade.velocity = Vector2.DOWN * 600
	
	get_tree().current_scene.add_child(new_jade)
	shape_to_enable.disabled = false
	player.frames.play(animation)
	await player.frames.animation_finished
	player._set_state("idle")
			
func exit(_next_state: PlayerState) -> void:
	_disable_all_attack_shapes()
	player.frames.offset.y = 0

func _disable_all_attack_shapes() -> void:
	player.attack_hitbox_up.get_node("CollisionShape2D").disabled = true
	player.attack_hitbox_down.get_node("CollisionShape2D").disabled = true
	player.attack_hitbox_left.get_node("CollisionShape2D").disabled = true
	player.attack_hitbox_right.get_node("CollisionShape2D").disabled = true

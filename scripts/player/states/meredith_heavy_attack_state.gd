extends PlayerState

class_name MeredithHeavyAttackState

var is_charging = false

func enter(_prev_state):
	is_charging = false
	
func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("Heavy_Attack") and not is_charging:
		is_charging = true
		var animation := "heavy_attack_down"
		
		var shape_to_enable: CollisionShape2D
		match player.facing_direction:
			Vector2.LEFT, Vector2.RIGHT:
				animation = "heavy_attack_side"
				if player.frames.flip_h:
					shape_to_enable = player.attack_hitbox_left.get_node("CollisionShape2D")
				else:
					shape_to_enable = player.attack_hitbox_right.get_node("CollisionShape2D")
				player.frames.flip_h = !player.frames.flip_h
			Vector2.UP:
				animation = "heavy_attack_up"
				shape_to_enable = player.attack_hitbox_up.get_node("CollisionShape2D")
			Vector2.DOWN:
				animation = "heavy_attack_down"
				shape_to_enable = player.attack_hitbox_down.get_node("CollisionShape2D")
		
		shape_to_enable.disabled = false
		player.frames.play(animation)
		
	elif Input.is_action_pressed("Heavy_Attack") and is_charging:
		player.velocity = player.facing_direction.normalized() * player.speed * 2
		
	if Input.is_action_just_released("Heavy_Attack"):
		player._set_state("idle")

func exit(_next_state: PlayerState) -> void:
	player.velocity = Vector2.ZERO
	_disable_all_attack_shapes()
	player.frames.flip_h = !player.frames.flip_h
	player.frames.offset.y = 0

func _disable_all_attack_shapes() -> void:
	player.attack_hitbox_up.get_node("CollisionShape2D").disabled = true
	player.attack_hitbox_down.get_node("CollisionShape2D").disabled = true
	player.attack_hitbox_left.get_node("CollisionShape2D").disabled = true
	player.attack_hitbox_right.get_node("CollisionShape2D").disabled = true

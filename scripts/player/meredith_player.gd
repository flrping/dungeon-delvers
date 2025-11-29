extends Player

class_name MeredithPlayer

@onready var attack_hitbox_up: Area2D  = $AttackUpHitbox
@onready var attack_hitbox_down: Area2D  = $AttackDownHitbox
@onready var attack_hitbox_left: Area2D  = $AttackLeftHitbox
@onready var attack_hitbox_right: Area2D  = $AttackRightHitbox

func _process(delta: float) -> void:
	_check_damage_sources(delta)
	_attack(delta)
	_apply_movement(delta)
	
	if i_frame_timer > 0.0:
		i_frame_timer -= delta
		i_frame_timer = max(i_frame_timer, 0.0)

func _attack(_delta) -> void:
	if is_attacking:
		return
	
	if Input.is_action_just_pressed("Light_Attack"):
		is_attacking = true
		prev_animation = frames.animation
		var attack_animation := ""
		
		_disable_all_attack_shapes()
		
		var shape_to_enable: CollisionShape2D
		
		if frames.animation == "walk_left":
			attack_animation = "attack_side"
			if frames.flip_h:
				shape_to_enable = attack_hitbox_right.get_node("CollisionShape2D")
			else:
				shape_to_enable = attack_hitbox_left.get_node("CollisionShape2D")
		elif frames.animation == "walk_up": 
			attack_animation = "attack_up"
			shape_to_enable = attack_hitbox_up.get_node("CollisionShape2D")
		else:
			attack_animation = "attack_down"
			shape_to_enable = attack_hitbox_down.get_node("CollisionShape2D")
			frames.offset.y = 8
			
		shape_to_enable.disabled = false
		frames.play(attack_animation)
		await frames.animation_finished
		frames.offset.y = 0
		frames.flip_v = false
		shape_to_enable.disabled = true

		frames.play(prev_animation)
		is_attacking = false

func _disable_all_attack_shapes() -> void:
	attack_hitbox_up.get_node("CollisionShape2D").disabled = true
	attack_hitbox_down.get_node("CollisionShape2D").disabled = true
	attack_hitbox_left.get_node("CollisionShape2D").disabled = true
	attack_hitbox_right.get_node("CollisionShape2D").disabled = true

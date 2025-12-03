extends PlayerState

class_name MarjorieAttackState

const threshold = 0.2
var timer = 0.0
var using_beam = false

@onready var beam = preload("res://scenes/entity/projectile/beam_projectile.tscn")

func enter(prev_state: PlayerState) -> void:
	timer = 0
	using_beam = false

func _physics_process(delta: float) -> void:
	var x = Input.get_axis("Left", "Right")
	var y = Input.get_axis("Up", "Down")
	
	if Input.is_action_pressed("Light_Attack"):
		timer += delta
	
	if timer >= threshold and not using_beam:
		using_beam = true
		var animation := "attack_down"
		
		var sprite_to_enable: AnimatedSprite2D
		var shape_to_enable: CollisionShape2D
		match player.facing_direction:
			Vector2.LEFT, Vector2.RIGHT:
				animation = "attack_side"
				if player.frames.flip_h:
					shape_to_enable = player.attack_hitbox_left.get_node("CollisionShape2D")
					sprite_to_enable = player.attack_hitbox_left.get_node("Frames")
				else:
					shape_to_enable = player.attack_hitbox_right.get_node("CollisionShape2D")
					sprite_to_enable = player.attack_hitbox_right.get_node("Frames")
			Vector2.UP:
				animation = "attack_up"
				shape_to_enable = player.attack_hitbox_up.get_node("CollisionShape2D")
				sprite_to_enable = player.attack_hitbox_up.get_node("Frames")
			Vector2.DOWN:
				animation = "attack_down"
				shape_to_enable = player.attack_hitbox_down.get_node("CollisionShape2D")
				sprite_to_enable = player.attack_hitbox_down.get_node("Frames")
				player.frames.offset.y = 8
		
		shape_to_enable.disabled = false
		sprite_to_enable.visible = true
		sprite_to_enable.play()
		player.frames.play(animation)
	elif timer >= threshold and using_beam:
		player.velocity = Vector2(x, y).normalized() * player.speed
	
	if Input.is_action_just_released("Light_Attack"):
		if timer < threshold:
			var animation := "attack_down"
			var new_beam = beam.instantiate()
			new_beam.position = player.position
			
			match player.facing_direction:
				Vector2.LEFT, Vector2.RIGHT:
					animation = "attack_side"
					if player.frames.flip_h:
						new_beam.velocity = Vector2.LEFT * 600
					else:
						new_beam.velocity = Vector2.RIGHT * 600
					player.frames.flip_h = !player.frames.flip_h
				Vector2.UP:
					animation = "attack_up"
					new_beam.velocity = Vector2.UP * 600
				Vector2.DOWN:
					animation = "attack_down"
					new_beam.velocity = Vector2.DOWN * 600
			
			get_tree().current_scene.add_child(new_beam)
			player.frames.play(animation)

		player._set_state("idle")
			
func exit(_next_state: PlayerState) -> void:
	_disable_all_attack_shapes()
	player.frames.flip_h = !player.frames.flip_h
	player.frames.offset.y = 0

func _disable_all_attack_shapes() -> void:
	player.attack_hitbox_up.get_node("CollisionShape2D").disabled = true
	player.attack_hitbox_down.get_node("CollisionShape2D").disabled = true
	player.attack_hitbox_left.get_node("CollisionShape2D").disabled = true
	player.attack_hitbox_right.get_node("CollisionShape2D").disabled = true
	player.attack_hitbox_up.get_node("Frames").visible = false
	player.attack_hitbox_down.get_node("Frames").visible = false
	player.attack_hitbox_left.get_node("Frames").visible = false
	player.attack_hitbox_right.get_node("Frames").visible = false

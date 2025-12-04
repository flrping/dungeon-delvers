extends PlayerState

class_name MeredithIdleState

func enter(_prev_state: PlayerState) -> void:
	player.velocity = Vector2.ZERO
	player.frames.play("idle")

func physics_update(_delta):
	var x = Input.get_axis("Left", "Right")
	var y = Input.get_axis("Up", "Down")
	
	if x != 0 or y != 0:
		player._set_state("move")
		return
		
	if Input.is_action_just_pressed("Light_Attack"):
		player._set_state("light_attack")
	elif Input.is_action_just_pressed("Heavy_Attack"):
		player._set_state("heavy_attack")

extends PlayerState

class_name PlayerMoveState

func enter(_prev_state):
	player.frames.play("walk_down")

func physics_update(_delta):
	var x = Input.get_axis("Left", "Right")
	var y = Input.get_axis("Up", "Down")
	
	if x == 0 and y == 0:
		player._set_state("idle")
		return
		
	player.velocity = Vector2(x, y).normalized() * player.SPEED
	if abs(x) > 0:
		player.frames.play("walk_right")
		player.frames.flip_h = x < 0
		
		if x < 0:
			player.facing_direction = Vector2.LEFT
		else:
			player.facing_direction = Vector2.RIGHT 
	elif y > 0:
		player.frames.play("walk_down")
		player.facing_direction = Vector2.DOWN
	elif y < 0:
		player.frames.play("walk_up")
		player.facing_direction = Vector2.UP
	
	player.move_and_slide()
	
	if Input.is_action_just_pressed("Light_Attack"):
		player._set_state("attack")

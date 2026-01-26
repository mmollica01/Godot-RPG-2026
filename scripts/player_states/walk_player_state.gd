class_name WalkPlayerState extends BasePlayerState

func enter(player: Player) -> void:
	player.anim_tree.set("parameters/movement/transition_request", "walk")

func pre_update(player: Player) -> void:
	var current_speed: float = player.get_current_speed()

	if not player.is_on_floor():
		player.change_state(PlayerStates.FALL)
	elif current_speed > player.RUN_SPEED:
		player.change_state(PlayerStates.RUN)
	elif current_speed == 0.0:
		player.change_state(PlayerStates.IDLE)
	elif Input.is_action_just_pressed("jump"):
		player.change_state(PlayerStates.JUMP)

func update(player: Player, _delta: float) -> void:
	var direction: Vector3 = player.get_movement_input()
	player.update_velocity(direction)
	player.move_and_slide()
	# Scale walk animation speed based on current speed
	var walk_speed: float = lerpf(0.5, 1.75, player.get_current_speed()/player.RUN_SPEED)
	player.anim_tree.set("parameters/TimeScale/scale", walk_speed)

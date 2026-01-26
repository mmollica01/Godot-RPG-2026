class_name RunPlayerState extends BasePlayerState


func enter(player: Player) -> void:
	player.anim_tree.set("parameters/movement/transition_request", "run")

func pre_update(player: Player) -> void:
	var current_speed: float = player.get_current_speed()

	if not player.is_on_floor():
		player.change_state(PlayerStates.FALL)
	elif current_speed == 0.0:
		player.change_state(PlayerStates.IDLE)
	elif current_speed < player.RUN_SPEED:
		player.change_state(PlayerStates.WALK)
	elif Input.is_action_just_pressed("jump"):
		player.change_state(PlayerStates.JUMP)

func update(player: Player, _delta: float) -> void:
	var direction: Vector3 = player.get_movement_input()
	player.update_velocity(direction)
	player.move_and_slide()
	# Add lean to run animation based on movement direction
	var lean: float = direction.dot(player.global_basis.x)
	player.last_lean = lerpf(player.last_lean, lean, 0.3)
	player.anim_tree.set("parameters/run_lean/add_amount", player.last_lean)

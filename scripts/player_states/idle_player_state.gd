class_name IdlePlayerState extends BasePlayerState

func enter(player: Player) -> void:
	player.anim_tree.set("parameters/movement/transition_request", "idle")

func pre_update(player: Player) -> void:
	var direction: Vector3 = player.get_movement_input()

	if not player.is_on_floor():
		player.change_state(PlayerStates.FALL)
	elif direction.length() > 0.0:
		player.change_state(PlayerStates.WALK)
	elif Input.is_action_just_pressed("jump"):
		player.change_state(PlayerStates.JUMP)

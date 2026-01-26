class_name FallPlayerState extends BasePlayerState

func enter(player: Player) -> void:
	player.anim_tree.set("parameters/movement/transition_request", "fall")

func pre_update(player: Player) -> void:
	if player.is_on_floor():
		player.change_state(PlayerStates.IDLE)

func update(player: Player, delta: float) -> void:
	var direction: Vector3 = player.get_movement_input()
	player.update_velocity(direction)
	player.velocity += player.get_gravity() * delta
	player.move_and_slide()

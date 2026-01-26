class_name JumpPlayerState extends BasePlayerState

func enter(player: Player) -> void:
	player.velocity.y = player.jump_velocity

func pre_update(player: Player) -> void:
	player.change_state(PlayerStates.FALL)

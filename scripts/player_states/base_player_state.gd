class_name BasePlayerState extends RefCounted

## Called when first entering a state
func enter(player: Player) -> void:
	pass

## Called when leaving a state
func exit(player: Player) -> void:
	pass

## Called every physics frame while in this state
func update(player: Player, _delta: float) -> void:
	pass

## Called right before update, allows for state changes
func pre_update(player: Player) -> void:
	pass

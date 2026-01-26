class_name Player extends CharacterBody3D

@export var base_speed: float = 5.0
@export var jump_velocity: float = 5.5

@onready var camera: Camera3D = $SpringArm3D/Camera3D
@onready var anim_player: AnimationPlayer = $Mesh/AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree

const RUN_SPEED: float = 4.0

var last_lean: float = 0.0
var state: BasePlayerState = PlayerStates.IDLE

func _ready() -> void:
	state.enter(self)

## Transitions to the state passed as arguement
func change_state(next_state: BasePlayerState) -> void:
	state.exit(self)
	state = next_state
	state.enter(self)

func _physics_process(delta: float) -> void:
	state.pre_update(self)
	state.update(self, delta)

## Applies velocity based on directional input
func update_velocity(direction: Vector3, speed: float = base_speed) -> void:
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		_turn_to(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

func _turn_to(dir: Vector3) -> void:
	var yaw: float = atan2(-dir.x, -dir.z)
	yaw = lerp_angle(rotation.y, yaw, 0.2)
	rotation.y = yaw

## Reads directional input for the player, handles it, and returns it
func get_movement_input() -> Vector3:
	var input_dir := Input.get_vector("move_left", "move_right", "move_fwd", "move_back")
	var direction := (camera.global_basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = Vector3(direction.x, 0.0, direction.z).normalized() * input_dir.length()
	return direction

## Get player's current speed
func get_current_speed() -> float:
	return velocity.length()

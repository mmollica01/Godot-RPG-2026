extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 5.5
var last_lean: float = 0.0

@onready var camera: Camera3D = $SpringArm3D/Camera3D
@onready var anim_player: AnimationPlayer = $Mesh/AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("move_left", "move_right", "move_fwd", "move_back")
	var direction := (camera.global_basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = Vector3(direction.x, 0.0, direction.z).normalized() * input_dir.length()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		_turn_to(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

	## Temporary until implementing FSM
	var current_speed: float = velocity.length()
	if !is_on_floor():
		anim_tree.set("parameters/movement/transition_request", "fall")
	elif current_speed > 4:
		anim_tree.set("parameters/movement/transition_request", "run")
		var lean: float = direction.dot(global_basis.x)
		last_lean = lerpf(last_lean, lean, 0.3)
		anim_tree.set("parameters/run_lean/add_amount", last_lean)
	elif current_speed > 0:
		anim_tree.set("parameters/movement/transition_request", "walk")
		var walk_speed: float = lerpf(0.5, 1.75, current_speed/4)
		anim_tree.set("parameters/TimeScale/scale", walk_speed)
	else:
		anim_tree.set("parameters/movement/transition_request", "idle")

func _turn_to(dir: Vector3) -> void:
	var yaw: float = atan2(-dir.x, -dir.z)
	yaw = lerp_angle(rotation.y, yaw, 0.2)
	rotation.y = yaw

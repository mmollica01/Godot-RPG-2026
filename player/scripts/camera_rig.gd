extends SpringArm3D

@export var controller_sens: float = 180.0
@export var mouse_sens: float = 0.1

var mouse_input: Vector2 = Vector2.ZERO
var camera_height: float = self.position.y

@onready var camera: Camera3D = $Camera3D
@onready var player: CharacterBody3D = get_parent()

func _ready() -> void:
	spring_length = camera.position.z
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input = -event.relative * mouse_sens
	elif event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	_handle_look(delta)

func _physics_process(_delta: float) -> void:
	self.position = player.position + Vector3(0, camera_height, 0)

func _handle_look(delta: float) -> void:
	var look_input: Vector2 = Input.get_vector("look_right", "look_left", "look_down", "look_up")
	look_input = look_input * controller_sens * delta
	look_input += mouse_input
	mouse_input = Vector2.ZERO
	rotation_degrees.x += look_input.y
	rotation_degrees.y += look_input.x
	rotation_degrees.x = clampf(rotation_degrees.x, -60, 45)

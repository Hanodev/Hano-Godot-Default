extends CharacterBody3D


@onready var camera_3d: Camera3D = %Camera3D
@onready var camera_holder: Node3D = $CameraPivot/CameraHolder

@export var jump_strength:= 20.0
@export var gravity:= 22.0
@export var speed:= 18.0
@onready var model: Node3D = $Model
@onready var rig: Node3D = $Model/Rig
@onready var marker_3d: Marker3D = $CameraPivot/CameraHolder/SpringArm3D/Marker3D

const mouse_sensitivity:= 0.05
@onready var animation_player: AnimationPlayer = $Model/AnimationPlayer

var attacking:= false
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await get_tree().create_timer(0.5).timeout
	for portal: Portal3D in get_tree().get_nodes_in_group("Portal"):
		print(portal)
		portal.player_camera = camera_3d

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_holder.rotation.x += deg_to_rad(-event.relative.y) * mouse_sensitivity
		rotation.y += deg_to_rad(-event.relative.x) * mouse_sensitivity
		camera_holder.rotation.x = clamp(camera_holder.rotation.x,deg_to_rad(-90.0),deg_to_rad(40.0))

func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector(&"Left",&"Right",&"Forward",&"Backward")
	if camera_3d.top_level:
		camera_3d.global_position = lerp(camera_3d.global_position, marker_3d.global_position, 8.0 * delta)
		camera_3d.global_rotation.y = lerp_angle(marker_3d.global_rotation.y, marker_3d.global_rotation.y, 8.0 * delta)
		camera_3d.global_rotation.x = lerp_angle(marker_3d.global_rotation.x, marker_3d.global_rotation.x, 8.0 * delta)
	if input_direction:
		var rig_rot = global_transform.basis.y * (Vector2(input_direction.x,input_direction.y * -1).angle() + deg_to_rad(-90))
		rig.rotation.y = lerp_angle(rig.rotation.y,rig_rot.y,8.0 * delta)
	move_and_slide()

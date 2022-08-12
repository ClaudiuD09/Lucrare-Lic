extends KinematicBody

var direction = Vector3.FORWARD
var velocity = Vector3.ZERO

var strafe_dir = Vector3.ZERO
var strafe = Vector3.ZERO

var vertical_velocity = 0
var gravity = 20
var jump = 10

var movement_speed = 0
var walk_speed = 10
const rot = 10
var acceleration = 5
var mesh_acc=35
var angular_acceleration = 7


func _ready():
	direction = Vector3.BACK.rotated(Vector3.UP, $Camroot/h.global_transform.basis.get_euler().y)
	



func _physics_process(delta):
	
	
	
	
	if Input.is_action_pressed("aim"):
		$AnimationTree.set("parameters/aim_transition/current", 0)
	else:
		$AnimationTree.set("parameters/aim_transition/current", 1)
	
	var h_rot = $Camroot/h.global_transform.basis.get_euler().y
	
	if Input.is_action_pressed("up") ||  Input.is_action_pressed("down") ||  Input.is_action_pressed("left") ||  Input.is_action_pressed("right"):
		direction = Vector3(Input.get_action_strength("right") - Input.get_action_strength("left"),
					0,
					Input.get_action_strength("down") - Input.get_action_strength("up"))



		strafe_dir = direction
		
		direction = direction.rotated(Vector3.UP, h_rot).normalized()
		
		
		movement_speed = walk_speed
		$AnimationTree.set("parameters/move_blend/blend_amount", lerp($AnimationTree.get("parameters/move_blend/blend_amount"),1, delta* mesh_acc))
	
	
	
	
	else:
		$AnimationTree.set("parameters/move_blend/blend_amount", lerp($AnimationTree.get("parameters/move_blend/blend_amount"), 0, delta * mesh_acc))
		movement_speed = 0
		strafe_dir = Vector3.ZERO
		
		if $AnimationTree.get("parameters/aim_transition/current") == 0:
			direction = $Camroot/h.global_transform.basis.z
	
	
	velocity = lerp(velocity, direction * movement_speed, delta * acceleration)
	
	
	
	
	move_and_slide(velocity + Vector3.DOWN * vertical_velocity ,Vector3.UP)
	
	if !is_on_floor():
		vertical_velocity += gravity * delta
	else:
		vertical_velocity=0
	
	
	
	
	if $AnimationTree.get("parameters/aim_transition/current") == 0:
		$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, atan2(direction.x,direction.z), delta * angular_acceleration)
	else:
		$Mesh.rotation.y = lerp_angle($Mesh.rotation.y, h_rot, delta * angular_acceleration)
	
	strafe = lerp(strafe, strafe_dir , delta * mesh_acc)
	
	$AnimationTree.set("parameters/strafe/blend_position", Vector2(-strafe.x, strafe.z))
	
	
	if Input.is_action_just_pressed("jump"):
		vertical_velocity = -jump






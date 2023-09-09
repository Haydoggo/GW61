extends CharacterBody2D


@export_group("Movement")
@export var grapple_range = 1000.0
@export var max_walk_speed = 300.0
@export var walk_acceleration = 1500.0
@export var floor_friction = 1500.0
@export var sliding_friction = 300.0
@export var air_acceleration = 100.0
@export var boost_speed = 300.0
@export var jump_speed = -400.0
@export var min_slide_speed = 50.0

@onready var grapple_ray: RayCast2D = $GrappleRay
@onready var grapple_line: Line2D = $GrappleLine


var can_grapple = true
var is_grappling = false
var is_sliding = false
var grapple_length = 0.0
var hook_position = Vector2()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		is_sliding = false

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	$GPUParticles2D.emitting = false
	if is_on_floor():
		if direction:
			velocity.x = move_toward(velocity.x, direction * max_walk_speed, walk_acceleration*delta)
		elif is_grappling or is_sliding:
			velocity.x = move_toward(velocity.x, 0, sliding_friction*delta*0.2)
		else:
			velocity.x = move_toward(velocity.x, 0, floor_friction*delta)
		if Input.is_action_just_pressed("slide") and abs(velocity.x) > min_slide_speed:
			is_sliding = true
		if abs(velocity.x) > max_walk_speed:
			$GPUParticles2D.emitting = true
	elif direction != 0:
		velocity.x += direction*delta*air_acceleration
	if abs(velocity.x) < min_slide_speed:
		is_sliding = false
	
	if Input.is_action_just_pressed("grapple") and can_grapple:
		grapple_ray.target_position = grapple_ray.get_local_mouse_position().normalized()*grapple_range
		grapple_ray.force_raycast_update()
		if grapple_ray.get_collider():
			is_grappling = true
			hook_position = grapple_ray.get_collision_point()
			grapple_length = hook_position.distance_to(grapple_ray.global_position)
	
	if Input.is_action_just_released("grapple") and is_grappling:
		is_grappling = false
	
	if Input.is_action_just_pressed("retract") and is_grappling:
		velocity += grapple_ray.global_position.direction_to(hook_position) * boost_speed
		is_grappling = false
	
	if is_grappling:
		var hook_dir = hook_position - grapple_ray.global_position
		if hook_dir.dot(velocity) < 0 and hook_dir.length() >= grapple_length:
			velocity = velocity.project(hook_dir.orthogonal())
		velocity += (hook_dir - hook_dir.limit_length(grapple_length)) * 10
	
	move_and_slide()
	# Visuals
	if is_grappling:
		grapple_line.show()
		grapple_line.points[1] = grapple_line.to_local(hook_position)
	else:
		grapple_line.hide()
	if is_sliding:
		$Sprite2D.scale.y = 0.5*0.5
		$Sprite2D.position.y = 16
	else:
		$Sprite2D.scale.y = 1*0.5
		$Sprite2D.position.y = 0
		

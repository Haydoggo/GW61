extends CharacterBody2D



@export var instant_retract = true
@export var auto_retract = false
@export_category("Movement Parameters")
## Movement Parameters
@export var mp : MovementParams

@onready var grapple_ray: RayCast2D = $GrappleRay
@onready var grapple_line: Line2D = $GrappleLine


var can_grapple = true
var is_grappling = false
var is_sliding = false
var grapple_length = 0.0
var hook_position = Vector2()

func _physics_process(delta: float) -> void:

	

	# Walking + friction
	var direction := Input.get_axis("move_left", "move_right")
	$FloorDust.emitting = false
	modulate = Color.WHITE
	if is_on_floor():
		var at_sliding_speed = abs(velocity.x) > mp.max_walk_speed
		if (not at_sliding_speed and direction) or (at_sliding_speed and (sign(direction)==sign(-velocity.x))):
			velocity.x = move_toward(velocity.x, direction * mp.max_walk_speed, mp.walk_acceleration*delta)
		elif is_grappling or is_sliding:
			modulate = Color.AQUA
			velocity.x = move_toward(velocity.x, 0, mp.sliding_friction*delta)
		else:
			modulate = Color.YELLOW
			velocity.x = move_toward(velocity.x, 0, mp.floor_friction*delta)
		if Input.is_action_just_pressed("slide") and abs(velocity.x) > mp.min_slide_speed:
			is_sliding = true
		if at_sliding_speed:
			$FloorDust.emitting = true
	elif direction != 0:
		velocity.x += direction*delta*mp.air_acceleration
	if abs(velocity.x) < mp.min_slide_speed:
		is_sliding = false
	
	# Add the gravity.
	$LeftWallDust.emitting = false
	$RightWallDust.emitting = false
	if not is_on_floor():
		velocity.y += mp.gravity * delta
		if is_on_wall():
			if velocity.y > mp.wall_slide_speed and direction:
				velocity.y = move_toward(velocity.y, mp.wall_slide_speed, delta * mp.floor_friction)
			if abs(velocity.y)>mp.wall_slide_speed*0.3:
				if direction > 0:
					$RightWallDust.emitting = true
				if direction < 0:
					$LeftWallDust.emitting = true
	
	# Jumping
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = mp.jump_speed
			is_sliding = false
		if is_on_wall_only() and direction:
			velocity.y = mp.jump_speed
			velocity.x = mp.jump_speed * direction
			is_grappling = false
	
	if Input.is_action_just_pressed("grapple") and can_grapple:
		grapple_ray.target_position = grapple_ray.get_local_mouse_position().normalized()*mp.grapple_range
		grapple_ray.force_raycast_update()
		if grapple_ray.get_collider():
			is_grappling = true
			hook_position = grapple_ray.get_collision_point()
			grapple_length = hook_position.distance_to(grapple_ray.global_position)
			
			var map = grapple_ray.get_collider() as WorldMap
			if map:
				var hook_pos_adjusted = grapple_ray.get_collision_point() - grapple_ray.get_collision_normal()
				if map.global_to_atlas_coords(hook_pos_adjusted) == WorldMap.boost_tile:
					var pull_vel = grapple_ray.global_position.direction_to(hook_position) * mp.retraction_power
					if velocity.dot(pull_vel) < 0:
						velocity = velocity.project(pull_vel.orthogonal())
#						var orthogonal_pull_vec = pull_vel.normalized().orthogonal()
#						orthogonal_pull_vec *= sign(velocity.dot(orthogonal_pull_vec))
#						velocity *= orthogonal_pull_vec
					velocity += pull_vel
	
	if Input.is_action_just_released("grapple") and is_grappling:
		is_grappling = false
	
	if instant_retract:
		if Input.is_action_just_pressed("retract") and is_grappling:
			velocity += grapple_ray.global_position.direction_to(hook_position) * mp.retraction_power
			is_grappling = false
	else:
		if Input.is_action_pressed("retract") and is_grappling:
			grapple_length = move_toward(grapple_length, 0, mp.retraction_power * delta)
	
	if auto_retract:
		grapple_length = min(grapple_length, hook_position.distance_to(global_position))
	
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

func _draw() -> void:
	draw_arc(Vector2(0,0), mp.grapple_range, 0, TAU, 32, Color.WHITE)

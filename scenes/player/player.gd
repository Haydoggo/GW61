class_name Player extends CharacterBody2D

static var instance : Player

@export_category("Movement Parameters")
## Movement Parameters
@export var mp : MovementParams

@onready var grapple_ray: RayCast2D = $GrappleRay
@onready var grapple_line: Line2D = $GrappleLine
@onready var grapple_indicator: Line2D = $GrappleRay/GrappleIndicator
@onready var retraction_timer: Timer = $RetractionTimer
@onready var shape_cast: ShapeCast2D = $ShapeCast2D

var can_retract = false
var is_retracting = false
var is_grappling = false
var is_sliding = false
var grapple_length = 0.0
var hook_position = Vector2()
var ignored_tiles = []
var time_last_on_floor = 0.0

func _init() -> void:
	instance = self
	
func _physics_process(delta: float) -> void:
	player_movement(delta)
	grapple_movement(delta)
	
	# Colliding with tiles
	var kc = get_last_slide_collision()
	if kc:
		var p = kc.get_position() - kc.get_normal()
		var collider = kc.get_collider()
		if collider and collider.has_method("collide"):
			collider.collide()
		var map = collider as WorldMap
		if map:
			var c = map.local_to_map(map.to_local(p))
			if c not in ignored_tiles:
				ignored_tiles.append(c)
				get_tree().create_timer(0.5).timeout.connect(func():ignored_tiles.erase(c))
				if map.get_properties(p) & WorldMap.TileProperty.JUMP:
					velocity -= Vector2.UP.rotated(-PI/2*map.get_alt_index(p)) * mp.jump_speed * 2
				if map.get_properties(p) & WorldMap.TileProperty.DEATH:
					create_tween().tween_property(self, "modulate", Color.WHITE, 1.0).from(Color.RED)
	
	# Preemptive Collision check:
	shape_cast.target_position = velocity * delta
	for i in shape_cast.get_collision_count():
		var c = shape_cast.get_collider(i)
		if c and c.has_method("collide"):
			c.collide()
	
	move_and_slide()
			
	# Visuals
	if is_grappling:
		grapple_line.show()
		grapple_line.points[0] = grapple_line.to_local(hook_position)
	else:
		grapple_line.hide()
	if is_sliding:
		$Sprite2D.scale.y = 0.5*0.5
		$Sprite2D.position.y = 16
	else:
		$Sprite2D.scale.y = 1*0.5
		$Sprite2D.position.y = 0

func _draw() -> void:
	draw_arc(Vector2(0,0), mp.grapple_range, 0, TAU, 100, Color.WHITE)

func player_movement(delta: float) -> void:
	# Walking + friction
	var direction := Input.get_axis("move_left", "move_right")
	$FloorDust.emitting = false
	var current_time = Time.get_ticks_msec()/1000.0
	if is_on_floor():
		time_last_on_floor = current_time
		var at_skidding_speed = abs(velocity.x) > mp.max_walk_speed
		if at_skidding_speed:
			$FloorDust.emitting = true
		# Apply walking force only if it will increase the player's speed in the intended direction
		if sign(direction)==sign(-velocity.x):
			velocity.x = move_toward(velocity.x, direction * mp.max_walk_speed, mp.walk_acceleration*delta*3)
		elif not at_skidding_speed and direction:
			velocity.x = move_toward(velocity.x, direction * mp.max_walk_speed, mp.walk_acceleration*delta)
		# Apply ground friction otherwise
		elif is_grappling or is_sliding:
			velocity.x = move_toward(velocity.x, 0, mp.sliding_friction*delta)
		else:
			velocity.x = move_toward(velocity.x, 0, mp.floor_friction*delta)
		
		# Player slide action
		if Input.is_action_pressed("slide") and abs(velocity.x) > mp.min_slide_speed:
			is_sliding = true
		if abs(velocity.x) < mp.min_slide_speed:
			is_sliding = false
	
	# Air movement
	elif direction != 0:
		if sign(direction)==sign(-velocity.x):
			velocity.x += direction * delta * mp.walk_acceleration * 3
		if abs(velocity.x) < mp.max_walk_speed:
			velocity.x += direction * delta * mp.walk_acceleration
		else:
			velocity.x += direction * delta * mp.air_acceleration
	
	# Add the gravity.
	$LeftWallDust.emitting = false
	$RightWallDust.emitting = false
	if not is_on_floor():
		velocity.y += mp.gravity * delta
		
		# Wall sliding logic
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
		if is_on_floor() or (current_time - time_last_on_floor) < mp.jump_buffer_time:
			time_last_on_floor = 0.0
			velocity.y = mp.jump_speed
			is_sliding = false
		# Wall jumping
		if is_on_wall_only() and direction:
			velocity.y = mp.jump_speed
			velocity.x = mp.jump_speed * direction
			is_grappling = false

func grapple_movement(delta: float) -> void:
	# Grappling
	grapple_ray.target_position = grapple_ray.get_local_mouse_position().normalized()*mp.grapple_range
	grapple_ray.force_raycast_update()
	grapple_indicator.points[1] = grapple_ray.target_position
	
	var hit_block_properties = WorldMap.TileProperty.NONE
	grapple_indicator.default_color = Color.WHITE
	if grapple_ray.get_collider():
		var map = grapple_ray.get_collider() as WorldMap
		if map:
			var hook_pos_adjusted = grapple_ray.get_collision_point() - grapple_ray.get_collision_normal()
			hit_block_properties = map.get_properties(hook_pos_adjusted)
			if hit_block_properties & WorldMap.TileProperty.GRAPPLE:
				grapple_indicator.default_color = Color.GREEN_YELLOW
			if hit_block_properties & WorldMap.TileProperty.BOOST:
				grapple_indicator.default_color = Color.AQUA
	
	if Input.is_action_just_pressed("grapple"):
		if hit_block_properties & WorldMap.TileProperty.GRAPPLE:
			is_grappling = true
			hook_position = grapple_ray.get_collision_point()
			grapple_length = hook_position.distance_to(grapple_ray.global_position)
			if hit_block_properties & WorldMap.TileProperty.BOOST:
				is_retracting = true
				retraction_timer.wait_time = mp.retraction_time
				retraction_timer.start()
	
	if Input.is_action_just_released("grapple") and is_grappling:
		retraction_timer.stop()
		is_grappling = false
		is_retracting = false
	
	if is_retracting:
		var pull_vel = grapple_ray.global_position.direction_to(hook_position) * mp.retraction_power
		if velocity.dot(pull_vel) < 0:
			velocity = velocity.project(pull_vel.orthogonal())
		velocity += pull_vel * delta / max(mp.retraction_time, delta)
		
	
	if can_retract:
		if mp.instant_retract:
			if Input.is_action_just_pressed("retract") and is_grappling:
				velocity += grapple_ray.global_position.direction_to(hook_position) * mp.retraction_power
				is_grappling = false
		else:
			if Input.is_action_pressed("retract") and is_grappling:
				grapple_length = move_toward(grapple_length, 0, mp.retraction_power * delta)
		
	if mp.auto_retract:
		grapple_length = min(grapple_length, hook_position.distance_to(global_position))
	grapple_length = max(mp.min_grapple_length, grapple_length)
	
	if is_grappling:
		var hook_dir = hook_position - grapple_ray.global_position
		if hook_dir.dot(velocity) < 0 and hook_dir.length() >= grapple_length:
			velocity = velocity.project(hook_dir.orthogonal())
		velocity += (hook_dir - hook_dir.limit_length(grapple_length)) * 10

func _on_retraction_timer_timeout() -> void:
	is_retracting = false

class_name Player extends CharacterBody3D

@export var dash_speed: float = 20.0
@export var deceleration: float = 20.0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

enum State {
	IDLE,
	WALK,
	FALL,
	JUMP,
	DASH
}

var state: State = State.IDLE: set = set_state

func set_state(state_p: State) -> void: 
	state = state_p
	print(State.find_key(state))


func idle(delta: float) -> void:
	
	if not is_on_floor():
		state = State.FALL
		return
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state = State.JUMP
		velocity.y = JUMP_VELOCITY
		return
	
	var direction := get_input_direction()
	if direction:
		state = State.WALK
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		return
	
	# Decelerate.
	velocity.x = move_toward(velocity.x, 0, deceleration * delta)
	velocity.z = move_toward(velocity.z, 0, deceleration * delta)


func walk(delta: float) -> void:
	if not is_on_floor():
		state = State.FALL
		return
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state = State.JUMP
		velocity.y = JUMP_VELOCITY
		return
	
	var direction := get_input_direction()
	if not direction:
		state = State.IDLE
		return
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED


func jump(delta: float) -> void:
	if is_on_floor():
		state = State.IDLE
		return
	
	var direction := get_input_direction()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		velocity.z = move_toward(velocity.z, 0, deceleration * delta)
	
	if Input.is_action_just_pressed("jump"):
		state = State.DASH
		velocity = velocity.normalized() * dash_speed
		return
	
	velocity += get_gravity() * delta


func fall(delta: float) -> void:
	if is_on_floor():
		state = State.IDLE
		return
	
	var direction := get_input_direction()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		velocity.z = move_toward(velocity.z, 0, deceleration * delta)
	
	if Input.is_action_just_pressed("jump"):
		state = State.DASH
		velocity = velocity.normalized() * dash_speed
		return
	
	velocity += get_gravity() * delta


func dash(delta: float) -> void:
	if is_on_floor():
		state = State.IDLE
		return
	
	velocity += get_gravity() * delta


func get_input_direction() -> Vector3:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return direction


func _physics_process(delta: float) -> void:
	match(state):
		State.IDLE:
			idle(delta)
		State.WALK:
			walk(delta)
		State.JUMP:
			jump(delta)
		State.FALL:
			fall(delta)
		State.DASH:
			dash(delta)
	
	move_and_slide()

#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#state = State.JUMP
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#state = State.WALK
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#state = State.IDLE
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()

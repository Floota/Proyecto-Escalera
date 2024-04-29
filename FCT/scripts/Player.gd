extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FRICTION = 1500.0
var JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

func apply_gravity(delta):
	global.player_pos_y = position.y
	if not is_on_floor():
		velocity.y += gravity*1.1 * delta
		velocity.x*0.8
		global.on_floor = false;

func handle_air():
	if is_on_floor() or coyote_jump_timer.time_left < 0.0:
		global.on_floor = true
		hover_ready = true
		global.hovering = false
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
	else:
		#Shorthop
		if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

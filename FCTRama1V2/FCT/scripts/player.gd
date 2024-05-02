extends CharacterBody2D
class_name Player

var axis : Vector2 = Vector2.ZERO
var death : bool = false

@export_category("⚙️ Config")

@export_group("Motion")
var gravity : int = 16
const speed = 125.0
const acceleration = 650.0
const friction = 1500.0
var jump_acceleration = -250.0

@onready var coyote_jump_timer = $CoyoteJumpTimer

var initial_position : Vector2 = Vector2.ZERO

func _ready():
	initial_position = position
	
func _physics_process(delta):
	apply_gravity(delta)
	apply_friction(get_axis().x, delta)
	if not death:
		move_and_slide()
		animation_ctrl()
	

func _process(_delta):
	match death:
		true:
			death_ctrl()
		false:
			pass


func _input(event):
	if not death and is_on_floor() and event.is_action_pressed("ui_accept"):
		jump_ctrl()


func get_axis() -> Vector2: # Función para retornar la dirección pulsada.
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	return axis.normalized()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * 1.05


func apply_friction(input_axis, delta):
	#Aplica friccion al personaje, hace que tenga un poco mas de peso el movimiento
	if input_axis:
		velocity.x = move_toward(velocity.x,speed * input_axis, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func motion_ctrl():
	'''MOVIMIENTO'''
	# Esta línea va a controlar la dirección en la que mira el personaje, si el eje retornado es distinto de cero, entonces la escala del sprite en X es igual al eje retornado en X, sencillo y funcional.
	velocity.x = get_axis().x * speed
	velocity.y += gravity
	
	move_and_slide() # En el método move_and_slide va implicito el tiempo delta.
	var was_on_floor = is_on_floor()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		print(coyote_jump_timer.time_left)
		coyote_jump_timer.start()

func animation_ctrl():
	'''ANIMACIONES'''
	if get_axis().x != 0:
		$Sprite.flip_h = (get_axis().x < 0)
	# A modo de consejo, en condiciones simples, es preferible usar match en lugar de if, es más rápido.
	match is_on_floor():
		true: # Sencillo, si está tocando el suelo, entonces entra en este bloque de código.
			if get_axis().x != 0:
				$Sprite.play("Run")
			else:
				$Sprite.play("Idle")
		false: # De lo contrario, entra en este bloque de código.
			if velocity.y < 0: #  Si velocity.y es menor que cero, significa que se encuentra subiendo.
				$Sprite.play("Jump")
			else: # De lo contrario, está cayendo.
				$Sprite.play("Fall")


func death_ctrl() -> void:
	velocity.x = 0 # Bloqueamos la dirección en x.
	velocity.y += gravity # Mantenemos la gravedad, para que no quede flotando si muere en el aire.

# El salto lo hago en una función independiente para pasarlo en la función event, en lugar del process, con eso se gana rendimiento al evitar comprobaciones innecesarias.
func jump_ctrl():
	if is_on_floor() or coyote_jump_timer.time_left < 0.0:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = jump_acceleration
		else:
		#Shorthop
			if Input.is_action_just_released("ui_accept") and velocity.y < jump_acceleration / 2:
				print("shorthop")
				velocity.y = jump_acceleration / 2

func damage_ctrl() -> void:
	death = true
	$Sprite.set_animation("Death")


func _on_hit_point_body_entered(body):
	# Esto solo va a funcionar si es un enemigo y el personaje se encuentra cayendo, no subiendo.
	if body is EnemyBasic and velocity.y >= 0:
		body.damage_ctrl(1)



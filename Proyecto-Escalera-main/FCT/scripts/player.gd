extends CharacterBody2D
class_name Player

var axis : Vector2 = Vector2.ZERO
var death : bool = false

@export_category("⚙️ Config")

@export_group("Motion")
@export var speed : int = 128
@export var gravity : int = 16
@export var jump : int = 368

var initial_position : Vector2 = Vector2.ZERO

func _ready():
	initial_position = position
	
	
func _process(_delta):
	match death:
		true:
			death_ctrl()
		false:
			motion_ctrl()


func _input(event):
	if not death and is_on_floor() and event.is_action_pressed("ui_accept"):
		jump_ctrl(1)


func get_axis() -> Vector2: # Función para retornar la dirección pulsada.
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	return axis.normalized()


func motion_ctrl() -> void:
	'''MOVIMIENTO'''
	# Esta línea va a controlar la dirección en la que mira el personaje, si el eje retornado es distinto de cero, entonces la escala del sprite en X es igual al eje retornado en X, sencillo y funcional.
	if not get_axis().x == 0:
		$Sprite.scale.x = get_axis().x
	
	velocity.x = get_axis().x * speed
	velocity.y += gravity
	
	move_and_slide() # En el método move_and_slide va implicito el tiempo delta.
	
	'''ANIMACIONES'''
	# A modo de consejo, en condiciones simples, es preferible usar match en lugar de if, es más rápido.
	match is_on_floor():
		true: # Sencillo, si está tocando el suelo, entonces entra en este bloque de código.
			if not get_axis().x == 0:
				$Sprite.set_animation("Run")
			else:
				$Sprite.set_animation("Idle")
		false: # De lo contrario, entra en este bloque de código.
			if velocity.y < 0: #  Si velocity.y es menor que cero, significa que se encuentra subiendo.
				$Sprite.set_animation("Jump")
			else: # De lo contrario, está cayendo.
				$Sprite.set_animation("Fall")


func death_ctrl() -> void:
	velocity.x = 0 # Bloqueamos la dirección en x.
	velocity.y += gravity # Mantenemos la gravedad, para que no quede flotando si muere en el aire.
	move_and_slide()

# El salto lo hago en una función independiente para pasarlo en la función event, en lugar del process, con eso se gana rendimiento al evitar comprobaciones innecesarias.
func jump_ctrl(power : float) -> void: # Pido un parámetro para indicarle la fuerza de salto.
	# velocity es una variable afectada por move_and_slide, asi que no es necesario multiplicar por delta.
	velocity.y = -jump * power


func damage_ctrl() -> void:
	death = true
	$Sprite.set_animation("Death")


func _on_hit_point_body_entered(body):
	# Esto solo va a funcionar si es un enemigo y el personaje se encuentra cayendo, no subiendo.
	if body is EnemyBasic and velocity.y >= 0:
		body.damage_ctrl(1)
		jump_ctrl(0.75)



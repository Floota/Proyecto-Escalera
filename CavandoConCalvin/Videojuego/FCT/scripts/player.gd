extends CharacterBody2D

class_name Player

var axis : Vector2 = Vector2.ZERO
var death : bool = false

@export_category("⚙️ Config")
@export_group("Required References")
@export var gui : CanvasLayer
var hit = false

@export_group("Motion")
var gravity : int = 16
const speed = 125.0
const acceleration = 650.0
const friction = 1500.0
var jump_acceleration = -270.0
var currentX = 0

var current_npc = null
var dialog_open : bool = false

@onready var va_hitbox = $VerticalAttack/VAHitbox
@onready var ha_hitbox = $HorizontalAttack/HAHitbox
@onready var la_hitbox = $LowAttack/LAHitbox
@onready var vertical_attack = $VerticalAttack
@onready var horizontal_attack = $HorizontalAttack
@onready var low_attack = $LowAttack
@onready var attack_sprite = $Sprite/AttackSprite
@onready var sprite = $Sprite
@onready var attack_ready_timer = $AttackReadyTimer

var current_health = GLOBAL.health
signal health_changed(new_health)

var initial_position = GLOBAL.player_position

func _ready():
	pass

func _enter_tree():
	self.position = initial_position

	#Función innata que se ejecuta cada tick de fisicas (60)
func _physics_process(delta):
	apply_gravity(delta)
	apply_friction(get_axis().x, delta)
	if not death:
		move_and_slide()
		animation_ctrl()
	#Función innata que se ejecuta cada frame que se refresque la pantalla (60FPS)
func _process(_delta):
	if Input.is_action_just_pressed("attack"):
		attack_ready_timer.start()
		attack_ctrl()
	match death:
		true:
			death_ctrl()
		false:
			pass


func _input(event):
	if not death and is_on_floor() and event.is_action_pressed("ui_accept"):
		jump_ctrl()
		
	if not death and is_on_floor() and event.is_action_pressed("abrir_dialogo"):
		# Verifica si el jugador está dentro de la zona del NPC
		if dialog_open:
			$Camera2D/Interaction.stop()
			dialog_open = false
		# Si el diálogo no está abierto y el jugador está dentro de la zona del NPC, ábrelo
		elif is_on_floor() and $AreaInter.get_overlapping_bodies().size() > 0:
			if current_npc != null:
				$Camera2D/Interaction.start(current_npc.npc_id)
				dialog_open = true


func get_axis() -> Vector2: # Función para retornar la dirección pulsada.
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	return axis.normalized()
	
func get_axisY() -> Vector2: # Función para retornar la dirección pulsada.
	axis.y = int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))
	return axis.normalized()


func apply_gravity(_delta):
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

func animation_ctrl():
	'''ANIMACIONES'''
	if get_axis().x != 0:
		currentX = get_axis().x
		$Sprite.flip_h = (get_axis().x < 0)
		$Sprite.set_animation("Run")
	
	# A modo de consejo, en condiciones simples, es preferible usar match en lugar de if, es más rápido.
	match is_on_floor():
		true: # Sencillo, si está tocando el suelo, entonces entra en este bloque de código.
			if get_axis().x != 0:
				sprite.set_animation("Run")
			else:
				sprite.set_animation("Idle")
		false: # De lo contrario, entra en este bloque de código.
			if hit:
				sprite.play("Hit")
			else:
				if velocity.y < 0: #  Si velocity.y es menor que cero, significa que se encuentra subiendo.
					sprite.play("Jump")
				else: # De lo contrario, está cayendo.
					sprite.play("Fall")

func death_ctrl() -> void:
	velocity.x = 0 # Bloqueamos la dirección en x.
	velocity.y += gravity # Mantenemos la gravedad, para que no quede flotando si muere en el aire.

# El salto lo hago en una función independiente para pasarlo en la función event, en lugar del process, con eso se gana rendimiento al evitar comprobaciones innecesarias.
func jump_ctrl():
	if is_on_floor():
		hit = false
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = jump_acceleration
			$SFX/JumpSound.play()
		else:
		#Shorthop
			if Input.is_action_just_released("ui_accept") and velocity.y < jump_acceleration / 2:
				print("shorthop")
				velocity.y = jump_acceleration / 2
	
	#Función que maneja las hitboxes y animaciones de los ataques dependiendo del input del jugador
func attack_ctrl():
	if attack_ready_timer.time_left > 0.0:
		$SFX/AttackSound.play()
		if get_axisY().y != 0:
			if get_axisY().y > 0:
				attack_sprite.position.x = 0
				attack_sprite.position.y = -12
				vattack()
			else:
				vattack()
		else:
			if currentX > 0: 
				$HorizontalAttack.position.x = 3
				attack_sprite.position.x = 10
				attack_sprite.position.y = 0
				attack_sprite.flip_h = (currentX < 0)
				hattack()
			if currentX < 0:
				$HorizontalAttack.position.x = -25
				attack_sprite.position.x = -10
				attack_sprite.position.y = 0
				attack_sprite.flip_h = (currentX < 0)
				hattack()
	#Función que activa el ataque horizontal cuando se llama
func hattack():
	ha_hitbox.disabled = false
	attack_sprite.visible = true
	attack_sprite.play("HorizontalAttack")
	$Sprite.play("NormalAttack")
	await get_tree().create_timer(0.5).timeout 
	ha_hitbox.disabled = true
	attack_sprite.visible = false

	#Función que maneja los ataques verticales, el ataque algo si el eje de control Y es mayor que 0
	#y bajo si el valor es negativo, maneja la posición de las hitboxes además de las animaciones
func vattack():
	if get_axisY().y > 0: 
		va_hitbox.disabled = false
		attack_sprite.visible = true
		attack_sprite.play("HighAttack")
		await get_tree().create_timer(0.5).timeout 
		va_hitbox.disabled = true
		attack_sprite.visible = false
	else: 
		if currentX > 0: 
			low_attack.position.x = 3
			attack_sprite.position.x = 14
		if currentX < 0: 
			low_attack.position.x = -25
			attack_sprite.position.x = -11
		la_hitbox.disabled = false
		attack_sprite.visible = true
		attack_sprite.play("LowAttack")
		$Sprite.play("LowAttack")
		await get_tree().create_timer(0.5).timeout 
		la_hitbox.disabled = true
		attack_sprite.visible = false

	#Función que comprueba que el personaje ha muerto y activa la interfaz de game over
func damage_ctrl() -> void:
	death = true
	$Sprite.set_animation("Death")
	gui.game_over()

	#Función que activa la animación de daño además de disminuir la vida
func take_damage(amount: float):
	$SFX/DamageSound.play()
	hit = true
	print("Se ha llamado a take_damage() con:", amount, "de daño")
	current_health -= amount
	print("Después de recibir daño, health es:", current_health)
	GLOBAL.health = current_health
	if current_health <= 0:
		damage_ctrl()
	print(" health es:", GLOBAL.health)
	gui.update_health_display(current_health)
	#Knockback 
	
	#Funciónque aumenta la vida y cambia la interfaz
func add_health(amount: float):
	current_health += amount
	if current_health  == 3:
		current_health = GLOBAL.health
	GLOBAL.health = current_health
	gui.update_health_display(current_health)

	#Función que añade medio corazon cada vez que se activa
func collect_item_half_heart():
	add_health(0.5)

func _on_hit_point_body_entered(body):
	var enemies = get_tree().get_nodes_in_group("Enemy")
	# Esto solo va a funcionar si es un enemigo y el personaje se encuentra cayendo, no subiendo.
	if velocity.y >= 0:
		for enemy in enemies:
			if body == enemy and body.has_method("damage_ctrl"):
				body.damage_ctrl(1)
				break  # Si ya encontramos el enemigo y aplicamos daño, podemos salir del bucle

func _on_area_inter_body_entered(body): #Si esta en el area de interacción se activa
	if "npc_id" in body:
		current_npc = body

extends Enemy

@export var follow_speed : int = 50
@export var time_between_shots: float = 3.0

@export var bullet_scene: PackedScene
@onready var shoot_timer = $Timer

var player
var direction : int = 1 
var time_since_last_shot: float = 0

@onready var raycast_left = $LeftRayCast2D
@onready var raycast_right = $RightCast2D

func _ready():
	if GLOBAL.collected_disappear.has(get_name()):
		queue_free()
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	shoot_timer.wait_time = time_between_shots
	shoot_timer.start()

func _process(delta):
	time_since_last_shot += delta
	if health > 0: 
		motion_ctrl()

func motion_ctrl() -> void:
	if is_player_detected():
		follow_player()
		shoot()
	else:
		move_routine()

func is_player_detected() -> bool:
	return raycast_left.is_colliding() or raycast_right.is_colliding()

func shoot():
	if time_since_last_shot >= time_between_shots:
		var b = bullet_scene.instantiate()
		get_tree().current_scene.add_child(b)
		var shoot_direction = Vector2.RIGHT if raycast_right.is_colliding() else Vector2.LEFT
		if shoot_direction == Vector2(-1,0):
			$Marker2D.position = Vector2(-12,-3)
		else: 
			$Marker2D.position = Vector2(12,-3)
		#Ajusta la posicion de la bala para que comience desde el marcador
		b.global_position = $Marker2D.global_position
		$BulletSound.play()
		b.set_direction(shoot_direction)  #direccion de la bala
		time_since_last_shot = 0 

func move_routine():
	#Actualiza la orientacion de la animacion
	if direction < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	#Si detecta un precipicio o toca una pared, cambia de dirección
	if not $AnimatedSprite2D/RayCast2D.is_colliding() or is_on_wall():
		direction *= -1
	
	var new_velocity = Vector2(direction * speed, velocity.y)
	velocity = new_velocity
	velocity.y += gravity
	
	move_and_slide()

func follow_player() -> void:
	var direction_to_player = (player.global_position - global_position).normalized()
	if direction_to_player.x < 0: #Player a la izquierda del enemigo
		direction = -1
		$AnimatedSprite2D.flip_h = true
	else:
		direction = 1
		$AnimatedSprite2D.flip_h = false

	#Solo considera la  horizontal para seguir al jugador
	velocity.x = direction_to_player.x * follow_speed
	velocity.y = gravity
	move_and_slide()

func _on_timer_timeout():
	if is_player_detected():
		shoot()

extends CharacterBody2D

class_name EnemyBullet

@export_category("⚙️ Configuracion")

@export_group("Opciones")
@export var health : int = 1
@export var score : int = 100

@export_group("Movimiento")
@export var speed : int = 50
@export var follow_speed : int = 50
@export var gravity : int = 0
@export var time_between_shots: float = 1.0

@export var Bullet: PackedScene
var bullet_scene = preload("res://assets/scenes/enemies/bullet.tscn")
@onready var shoot_timer := $Timer

var player
var contador = 0
var direction : int = 1 
var time_since_last_shot: float = 0

@onready var raycast_left := $LeftRayCast2D
@onready var raycast_right := $RightCast2D

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	shoot_timer.wait_time = time_between_shots
	shoot_timer.start()

func _process(delta):
	time_since_last_shot += delta
	if health > 0: 
		motion_ctrl()

# Control de movimiento
func motion_ctrl() -> void:
	if is_player_detected():
		if player:
			follow_player()
			shoot()
	else:
		move_rutine()

func is_player_detected() -> bool:
	return raycast_left.is_colliding() or raycast_right.is_colliding()

func shoot():
	if time_since_last_shot >= time_between_shots:
		var b = bullet_scene.instantiate()
		get_parent().add_child(b)
		b.global_position = global_position  # Posiciona la bala en la posición del enemigo

		# Determina la dirección de disparo
		if raycast_left.is_colliding():
			b.set_target(raycast_left.get_collision_point())
		elif raycast_right.is_colliding():
			b.set_target(raycast_right.get_collision_point())
		time_since_last_shot = 0  # Reinicia el temporizador

func move_rutine():
	$AnimatedSprite2D.scale.x = direction
	# Si detecta un precipicio o toca una pared, cambia de dirección
	if not $AnimatedSprite2D/RayCast2D.is_colliding() or is_on_wall():
		direction *= -1
	
	velocity.x = direction * speed
	velocity.y += gravity
	move_and_slide()
	
func follow_player() -> void:
	var direction_to_player = (player.global_position - global_position).normalized()
	if direction_to_player.x < 0: #Player a la izq del enemigo
		direction = -1
		$AnimatedSprite2D.flip_h = true #Voltear la animacion
	else:
		direction = 1
		$AnimatedSprite2D.flip_h = false #Restablecer la orientacion
	
	# Solo considera la componente horizontal para seguir al jugador
	velocity.x = direction_to_player.x * follow_speed
	velocity.y = gravity  # Mantén la componente vertical igual a la gravedad
	move_and_slide()


func damage_ctrl(damage : int) -> void:
	health -= damage
	if health <= 0:
		$AnimatedSprite2D.play("death")
		$Collision.set_deferred("disabled", true)
		gravity = 0
		GLOBAL.score += score  # Sumamos puntos
		queue_free()

func _on_animated_sprite_2d_animation_finished(anim_name: String):
	if anim_name == "death":
		queue_free()

func _on_timer_timeout():
	if is_player_detected():
		shoot()

func _on_area_damage_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(0.5)
		

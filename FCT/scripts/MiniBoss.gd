extends CharacterBody2D

class_name MiniBoss

@export_category("⚙️ Configuracion")

@export_group("Opciones")
@export var health : int = 1
@export var score : int = 100

@export_group("Movimiento")
@export var speed : int = 70
@export var follow_speed : int = 50
@export var gravity : int = 0 

@export var Bullet: PackedScene
var bullet_scene = preload("res://assets/scenes/enemies/bullet.tscn")
@onready var shoot_timer := $Timer # Timer para controlar el intervalo de disparo

var is_player_inside_area: bool = false
var player = null
var direction : Vector2 = Vector2(1, 0) # Dirección inicial
var time_elapsed = 0
var change_direction_time = 3.0

func _ready():
	# Buscar al jugador, desde el grupo
	player = get_tree().get_nodes_in_group("player")[0] 
	shoot_timer.wait_time = 0.5 # Intervalo de tiempo entre disparos
	shoot_timer.start()

func _process(_delta):
	if health > 0: 
		motion_ctrl()

# Control de movimiento
func motion_ctrl() -> void:
		move_randomly()


func shoot():
	# Instancia un proyectil y lo dispara hacia el jugador
	var b = bullet_scene.instantiate()
	get_parent().add_child(b)
	b.global_position = global_position  # Posiciona la bala en la posición del enemigo
	b.set_target(player.global_position)  # Establece el objetivo de la bala
	

func move_randomly() -> void:
	time_elapsed += get_process_delta_time()
	if time_elapsed >= change_direction_time:
		direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		time_elapsed = 0.0 # Reiniciar 
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	velocity = direction * speed
	move_and_slide()


func damage_ctrl(damage : int) -> void:
	health -= damage
	
	if health <= 0:
		$AnimatedSprite2D.play("death")
		$CollisionShape2D.disabled = true
		$CollisionShape2D.monitoring = false # Desactiva el monitoreo de colisiones
		queue_free()

func _on_animated_sprite_2d_animation_finished():
	pass


func _on_area_follow_body_entered(body):
	if body is Player:
		is_player_inside_area = true
	
	
func _on_area_follow_body_exited(body):
	if body is Player:
		is_player_inside_area = false


func _on_area_damage_body_entered(body):
	if body is Player and health > 0:
		body.take_damage(0.5)


func _on_timer_timeout():
	if is_player_inside_area:
		shoot()

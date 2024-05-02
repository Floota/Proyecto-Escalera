extends CharacterBody2D
class_name EnemyJump

@export_category("⚙️ Configuracion")

@export_group("Opciones")
@export var health : int = 1
@export var score : int = 100

@export_group("Movimiento")
@export var speed : int = 16
@export var jump_speed : int = -400

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_jumping = false
var reset_position = position
var reset_velocity = velocity

@onready var reset_hit_area = $Area2D/CollisionShape2D.global_position
@onready var _animated_sprite = $AnimatedSprite2D
@onready var hit_box = $Area2D/CollisionShape2D

func _physics_process(delta):
	reset_position = position
	if is_jumping:
		$Area2D.monitoring = true
		$Collision.disabled = false
		_animated_sprite.play("jump")
		velocity.y += gravity * delta
	else:
		$Area2D.monitoring = false
		$Collision.disabled = true
		_animated_sprite.play("idle")
		position = reset_position
		velocity = reset_velocity
		$Area2D/CollisionShape2D.global_position = reset_hit_area
	
	if is_on_floor():
		is_jumping = false

	move_and_slide()
	
func damage_ctrl(damage : int) -> void:
	health -= damage
	
	if health <= 0:
		$AnimatedSprite2D.play("death")
		$Collision.disabled = true
		$Collision.monitoring = false #Desactiva el monitoreo de colisiones
		queue_free()
		
func jump():
	velocity.y = jump_speed

func _on_area_2d_body_entered(body):
	if body is Player and health > 0 and not is_jumping and is_on_floor():  # Verifica si el jugador está debajo del enemigo, no está saltando y está en el suelo
		body.damage_ctrl()  # Aplica daño al jugador
		velocity = Vector2.ZERO  # Detiene la velocidad del enemigo
		position = reset_position
		
func _on_tiempo_salto_timeout():
	is_jumping = true
	jump()


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		queue_free()

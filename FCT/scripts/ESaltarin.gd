extends CharacterBody2D

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
@onready var hit_box = $Area2D/CollisionPolygon2D

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

func jump():
	velocity.y = jump_speed

func damage_ctrl(damage : int) -> void:
	health -= damage
	
	if health <= 0:
		$AnimatedSprite2D.set_animation("death")
		#Establecer un parametro de forma segura, que en este caso ya que se desactiva la colision.
		$Collision.set_deferred("disabled", true)
		# Si se desactiva la colision, pero no seteamos la gravedad a 0, el personaje se hundiria mientras se reproduce la animación de muerte.
		gravity = 0
		GLOBAL.score += score #sumamos puntos

func _on_area_2d_body_entered(body):
	if body is Player:
		body.damage_ctrl()

func _on_tiempo_salto_timeout():
	is_jumping = true
	jump()

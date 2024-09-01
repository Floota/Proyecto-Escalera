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
var reset_position : Vector2
var reset_velocity : Vector2

@onready var reset_hit_area = $Area2D/CollisionShape2D.global_position
@onready var _animated_sprite = $AnimatedSprite2D
@onready var hit_box = $Area2D/CollisionShape2D

func _ready():
	reset_position = position
	reset_velocity = velocity

func _physics_process(delta):
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

func take_damage(damage : int) -> void:
	health -= damage
	
	if health <= 0:
		_animated_sprite.play("death")
		$Collision.disabled = true
		$Area2D.monitoring = false
		queue_free()

func jump():
	velocity.y = jump_speed
	
func _on_tiempo_salto_timeout():
	if not is_jumping:
		is_jumping = true
		jump()


func _on_animated_sprite_2d_animation_finished():
	if _animated_sprite.animation == "death":
		queue_free()

func _on_area_2d_body_entered(body):
	if body is Player and health > 0:
		body.take_damage(0.5)  # Aplica daño al jugador
		if not is_jumping:
			is_jumping = true
			jump()

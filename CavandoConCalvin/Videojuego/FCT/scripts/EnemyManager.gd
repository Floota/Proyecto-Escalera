extends CharacterBody2D
class_name Enemy

@export_category("⚙️ Configuracion")

@export_group("Opciones")
@export var health : int = 1
@export var score : int = 100

@export_group("Movimiento")
@export var speed : int = 16
@export var gravity : int = 16

@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	if GLOBAL.collected_disappear.has(get_name()):
		queue_free()

func _process(_delta):
	if health > 0: 
		motion_ctrl()

func motion_ctrl() -> void:
	pass

func take_damage(damage : int) -> void:
	health -= damage
	
	if health <= 0:
		$HurtboxArea/HurtboxShape.set_deferred("disabled", true)
		_animated_sprite.set_animation("death")
		gravity = 0
		GLOBAL.score += score

func _on_animated_sprite_2d_animation_finished():
	if _animated_sprite.animation == "death":
		GLOBAL.collected_disappear[get_name()] = true
		queue_free()
		
func _on_hitbox_area_body_entered(body):
	if body is Player and health > 0:
		body.take_damage(0.5)
		if ((abs(body.global_position.x) - abs(self.global_position.x)) > 0 ):
			body.velocity = Vector2(10 * 2 * 12, gravity * -11)
		else: 
			body.velocity = Vector2(10 * 2 * -12, gravity * -11)

func _on_hurtbox_area_area_entered(area):
	if area.is_in_group("attack") and health > 0:
		$Collision.set_deferred("disabled", true)
		$DeathSound.play()
		self.take_damage(1)

extends CharacterBody2D
class_name BasicEnemy

@export_category("⚙️ Configuracion")

@export_group("Opciones")
@export var health : int = 1
@export var score : int = 100

@export_group("Movimiento")
@export var speed : int = 16
@export var gravity : int = 16

@onready var _animated_sprite = $AnimatedSprite2D
var direction : int = 1 #Definir su direccion con una variable.

func _process(_delta):
	if health > 0: 
		motion_ctrl()


func motion_ctrl() -> void:
	_animated_sprite.scale.x = direction
	# Si detecta un precipicio o toca una pared, cambia de direccion
	if not $AnimatedSprite2D/RayCast2D.is_colliding() or is_on_wall():
		direction *= -1
	
	velocity.x = direction * speed
	velocity.y += gravity
	move_and_slide()


# Esta funcion la llama el player, pasandole como parámetro el daño recibido, de esa forma podemos hacer que reciba una cantidad de daño variable
func take_damage(damage : int) -> void:
	health -= damage
	
	if health <= 0:
		$HurtboxArea/HurtboxShape.set_deferred("disable", true)
		_animated_sprite.set_animation("death")
		#Establecer un parametro de forma segura, que en este caso ya que se desactiva la colisión.

		# Si se desactiva la colision, pero no seteamos la gravedad a 0, el personaje se hundiria mientras se reproduce la animación de muerte.
		gravity = 0
		GLOBAL.score += score #sumamos puntos


func _on_animated_sprite_2d_animation_finished():
	if _animated_sprite.animation == "death":
		queue_free()

func _on_area_2d_body_entered(body):
	if body is Player and health > 0:
		print("diff is ", body.global_position.x - self.global_position.x)
		print(body.global_position.x)
		print(self.global_position.x)
		
		body.take_damage(0.5)
		if ((body.global_position.x - self.global_position.x) > -17 ):
			body.velocity = Vector2(10 * 2 * 12, gravity * -11)
			print("fuck")
		else: 
			print("shit")
			body.velocity = Vector2(10 * 2 * -12, gravity * -11)

func _on_hurtbox_area_area_entered(area):
	if area.is_in_group("attack") and health > 0:
		self.take_damage(1)

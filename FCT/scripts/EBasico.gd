extends CharacterBody2D
class_name Enemy

@export_category("⚙️ Configuracion")

@export_group("Opciones")
@export var health : int = 1
@export var score : int = 100

@export_group("Movimiento")
@export var speed : int = 16
@export var gravity : int = 16


var direction : int = 1 #Definir su direccion con una variable.

func _process(_delta):
	if health > 0: 
		motion_ctrl()


func motion_ctrl() -> void:
	$AnimatedSprite2D.scale.x = direction
	# Si detecta un precipicio o toca una pared, cambia de direccion
	if not $AnimatedSprite2D/RayCast2D.is_colliding() or is_on_wall():
		direction *= -1
	
	velocity.x = direction * speed
	velocity.y += gravity
	move_and_slide()


# Esta funcion la llama el player, pasandole como parámetro el daño recibido, de esa forma podemos hacer que reciba una cantidad de daño variable
func damage_ctrl(damage : int) -> void:
	health -= damage
	
	if health <= 0:
		$AnimatedSprite2D.set_animation("death")
		#Establecer un parametro de forma segura, que en este caso ya que se desactiva la colisión.
		$Collision.set_deferred("disabled", true)
		# Si se desactiva la colision, pero no seteamos la gravedad a 0, el personaje se hundiria mientras se reproduce la animación de muerte.
		gravity = 0
		GLOBAL.score += score #sumamos puntos


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		queue_free()


func _on_area_2d_body_entered(body):
	if body is Player and health > 0:
		body.damage_ctrl()



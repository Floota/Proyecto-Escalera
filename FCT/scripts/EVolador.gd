extends CharacterBody2D
class_name EnemyFly

@export_category("⚙️ Configuracion")

@export_group("Opciones")
@export var health : int = 1
@export var score : int = 100

@export_group("Movimiento")
@export var speed : int = 70
@export var follow_speed : int = 50
@export var gravity : int = 0 


var is_player_inside_area: bool = false
var player = null
var direction : int = 1 
var time_elapsed = 0
var change_direction_time = 3.0

func _ready():
	#Buscar al jugador, desde el grupo
	player = get_tree().get_nodes_in_group("player")[0] 


func _process(_delta):
	if health > 0: 
		motion_ctrl()

#Control de movimiento
func motion_ctrl() -> void:
	if is_player_inside_area:
		if player:
			follow_player()
	else:
		move_horizontally()


func follow_player() -> void:
	var direction_to_player = (player.global_position - global_position).normalized()
	if direction_to_player.x < 0: #Player a la izq del enemigo
		direction = -1
		$AnimatedSprite2D.flip_h = true #Voltear la animacion
	else:
		direction = 1
		$AnimatedSprite2D.flip_h = false #Restablecer la orientacion
	velocity = direction_to_player * follow_speed
	move_and_slide()


func move_horizontally() -> void:
	#Incrementar el tiempo transcurrido
	time_elapsed += get_process_delta_time()
	
	#Si han pasado 3 segundos, cambiar la direccion
	if time_elapsed >= change_direction_time:
		
		direction *= -1
		time_elapsed = 0.0 #Reiniciar 
		if direction == -1:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	
	#Calcular la velocidad basada en la direccion actual
	velocity.x = speed * direction
	move_and_slide()


func take_damage(damage : int) -> void:
	health -= damage
	
	if health <= 0:
		$AnimatedSprite2D.play("death")
		$Hurtbox/HurtboxShape.set_deferred("disable", true)
		queue_free()


func _on_area_2d_body_entered(body):
	if body is Player and health > 0:
		body.take_damage(0.5)


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		queue_free()


func _on_area_follow_body_entered(body):
	if body is Player:
		is_player_inside_area = true
	
	
func _on_area_follow_body_exited(body):
	if body is Player:
		is_player_inside_area = false


func _on_hurtbox_area_entered(area):
	if area.is_in_group("attack") and health > 0:
		print("dmg")
		self.take_damage(1)

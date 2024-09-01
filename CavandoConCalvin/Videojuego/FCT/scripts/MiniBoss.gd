extends Enemy

@export var follow_speed : int = 50


@export var bullet_scene: PackedScene
@onready var shoot_timer := $Timer #Timer para controlar el intervalo de disparo

var is_player_inside_area: bool = false
var player = null
var direction : Vector2 = Vector2(1, 0)
var time_elapsed = 0
var change_direction_time = 3.0

func _ready():
	player = get_tree().get_nodes_in_group("player")[0] 
	shoot_timer.wait_time = 3 #Intervalo de tiempo entre disparos
	shoot_timer.start()

func _process(_delta):
	if health > 0: 
		motion_ctrl()

#Control de movimiento
func motion_ctrl() -> void:
		move_randomly()

#Control de disparo
func shoot():
	#Instancia un proyectil y lo dispara hacia el jugador
	var b = bullet_scene.instantiate()
	get_parent().add_child(b)
	b.global_position = global_position 
	b.set_target(player.global_position) 
	$BulletSound.play()

#Para que se mueva de forma aleatoria
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

func _on_area_follow_body_entered(body):
	if body is Player:
		is_player_inside_area = true
		$ScreechSound.play()
	
func _on_area_follow_body_exited(body):
	if body is Player:
		is_player_inside_area = false

func _on_timer_timeout():
	if is_player_inside_area and health > 0:
		shoot()

func _on_hurtbox_area_area_entered(area):
	if area.is_in_group("attack") and health > 0:
		self.take_damage(1)


extends Enemy

@export var jump_speed : int = -300

var is_jumping = false
var reset_position : Vector2
var reset_velocity : Vector2

@onready var reset_hit_area = $HitboxArea/Hitbox.global_position

func _ready():
	if GLOBAL.collected_disappear.has(get_name()):
		queue_free()
	reset_position = position
	reset_velocity = velocity
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if health > 0:  
		if is_jumping:
			$HitboxArea.monitoring = true
			$Collision.disabled = false
			_animated_sprite.play("jump")
			velocity.y += gravity * delta
		else:
			$HitboxArea.monitoring = false
			$Collision.disabled = true
			_animated_sprite.play("idle")
			position = reset_position
			velocity = reset_velocity
			$HitboxArea/Hitbox.global_position = reset_hit_area

		if is_on_floor():
			is_jumping = false

		move_and_slide()
	else:
		velocity = Vector2.ZERO

func jump():
	velocity.y = jump_speed
	
func _on_tiempo_salto_timeout():
	if not is_jumping:
		is_jumping = true
		jump()

func _on_hitbox_area_body_entered(body):
	if body is Player and health > 0:
		print(abs(body.global_position.x))
		print(abs(self.global_position.x))
		print(abs(body.global_position.x) - abs(self.global_position.x))
		if ((abs(body.global_position.x) - abs(self.global_position.x)) > 0 ):
			body.velocity = Vector2(10 * 2 * 12, -300)
		else: 
			body.velocity = Vector2(10 * 2 * -12, -300)
		body.take_damage(0.5)
		if not is_jumping:
			is_jumping = true
			jump()
			
func _on_hurtbox_area_area_entered(area):
	if area.is_in_group("attack") and health > 0 and is_jumping:
		$Collision.set_deferred("disabled", true)
		self.take_damage(1)

extends Area2D

@export var speed: int = 180
var target_position: Vector2
var destroy_threshold: float = 800.0

func _physics_process(delta):
	if target_position != null:
		move_towards_target(delta)
		if global_position.distance_to(target_position) <= 2:
			var tween = create_tween()
			tween.tween_property($BulletSprite2, "modulate", Color.TRANSPARENT, 1.0)
			
			queue_free() 
func _process(delta):
	pass

func move_towards_target(delta):
	if target_position != null:
		var direction = (target_position - global_position).normalized()
		position += direction * speed * delta

func set_target(target: Vector2):
	target_position = target
	
func _on_body_entered(body):
	if body is Player:
		body.take_damage(0.5)
		print("test0")
		if ((abs(body.global_position.x) - abs(self.global_position.x)) > 0 ):
			print("test1")
			body.velocity = Vector2(25 * 20, -300)
		else: 
			print("test2")
			body.velocity = Vector2(25 * -20, -300)
		queue_free()
	else:
		queue_free()



extends CharacterBody2D

@export var speed: int = 150
var direction: Vector2
var destroy_threshold: float = 1000.0

func _physics_process(delta):
	move(delta)

func _process(delta):
	pass

func move(delta):
	var motion = direction * speed * delta
	global_position += motion
	
func set_direction(new_direction: Vector2):
	direction = new_direction.normalized()

func _on_area_2d_body_entered(body):
	if body is Player:
		body.take_damage(0.5)
		if ((abs(body.global_position.x) - abs(self.global_position.x)) > 0 ):
			body.velocity = Vector2(400, -250)
		else: 
			body.velocity = Vector2(-400, -250) 
		queue_free()



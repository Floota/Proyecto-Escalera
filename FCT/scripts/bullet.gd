extends Area2D

@export var speed: int = 550
var target_position: Vector2
var destroy_threshold: float = 1000.0

func _physics_process(delta):
	if target_position != null:
		move_towards_target(delta)
		if global_position.distance_to(target_position) > destroy_threshold:
			queue_free()

func move_towards_target(delta):
	if target_position != null:
		var direction = (target_position - global_position).normalized()
		position += direction * speed * delta

func set_target(target: Vector2):
	target_position = target
	
func _on_body_entered(body):
	if body is Player:
		body.take_damage(0.5)
		queue_free()
	queue_free()

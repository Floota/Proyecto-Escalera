extends Enemy

var direction : int = 1

func motion_ctrl() -> void:
	_animated_sprite.scale.x = direction
	if not $AnimatedSprite2D/RayCast2D.is_colliding() or is_on_wall():
		direction *= -1
	
	velocity.x = direction * speed
	velocity.y += gravity
	move_and_slide()

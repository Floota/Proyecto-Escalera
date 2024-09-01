extends Node2D

func _on_area_2d_body_entered(body):
	if body is Player:
		body.take_damage(0.5) 
		body.velocity.y = -300

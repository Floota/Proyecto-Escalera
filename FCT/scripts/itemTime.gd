extends Area2D

func _on_body_entered(body):
	if body is Player:
			self.visible = false
			GLOBAL.time += 20
			GLOBAL.score += 50
			queue_free()

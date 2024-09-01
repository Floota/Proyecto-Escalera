extends Area2D


func _on_body_entered(body):
	if body is Player:
			self.visible = false
			GLOBAL.fruitSpecial += 1
			GLOBAL.score += 200
			queue_free()

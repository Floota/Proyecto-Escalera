extends Area2D

signal fruit_pick


func _on_body_entered(body):
	if body is Player:
			self.visible = false
			GLOBAL.fruit += 1
			GLOBAL.score += 100
			#Señal con script fruit
			fruit_pick.emit()
			await get_tree().create_timer(0.1).timeout
			queue_free()

extends Area2D

func _ready():
	if GLOBAL.collected_pickups.has(get_name()):
		queue_free()
	
func _on_body_entered(body):
	if body is Player:
		GLOBAL.collected_pickups[get_name()] = true
		self.visible = false
		GLOBAL.fruit += 1
		GLOBAL.score += 100
		queue_free()

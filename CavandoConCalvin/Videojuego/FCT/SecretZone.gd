extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_hit_box_area_entered(area):
	if area.is_in_group("attack"):
		var tween = create_tween()
		tween.tween_property($TileMap, "modulate", Color.TRANSPARENT, 1.0)
		await get_tree().create_timer(1).timeout 
		self.queue_free()


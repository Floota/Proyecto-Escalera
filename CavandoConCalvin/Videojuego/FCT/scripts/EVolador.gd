extends Enemy

@export var follow_speed : int = 50
var is_player_inside_area: bool = false
var player = null
var direction : int = 1 
var time_elapsed = 0
var change_direction_time = 3.0

func _ready():
	player = get_tree().get_nodes_in_group("player")[0] 

func motion_ctrl() -> void:
	if is_player_inside_area:
		if player:
			follow_player()
	else:
		move_horizontally()

func follow_player() -> void:
	var direction_to_player = (player.global_position - global_position).normalized()
	if direction_to_player.x < 0:
		direction = -1
		$AnimatedSprite2D.flip_h = true
	else:
		direction = 1
		$AnimatedSprite2D.flip_h = false
	velocity = direction_to_player * follow_speed
	move_and_slide()

func move_horizontally() -> void:
	time_elapsed += get_process_delta_time()
	if time_elapsed >= change_direction_time:
		direction *= -1
		time_elapsed = 0.0
		if direction == -1:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	
	velocity.x = speed * direction
	move_and_slide()

func _on_area_follow_body_entered(body):
	if body is Player:
		is_player_inside_area = true
	
func _on_area_follow_body_exited(body):
	if body is Player:
		is_player_inside_area = false

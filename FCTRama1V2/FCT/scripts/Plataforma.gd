extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("RESET")
	$"../Plataforma2/AnimationPlayer".play("platform2")

extends Control

func _ready():
	$Botones/Iniciar.grab_focus()


func _on_iniciar_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/level/escena_juego.tscn")


func _on_salir_pressed():
	get_tree().quit()

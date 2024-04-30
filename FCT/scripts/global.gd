extends Node

var save_path = ""

#Puntuacion
var score : int
# Frutas
var fruits: int = 0
# Tiempo total
var time: int = 170 

var game_data : Dictionary = {
	"score" : 0,
	"health" : 3,
	"position" : Vector2.ZERO,
	"fruits" : 0,
	"time" : 170
}

func save_game() -> void:
	
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	
	save_file.store_var(game_data)
	save_file = null

func load_game() -> void:
	if FileAccess.file_exists(save_path):
		var save_file = FileAccess.open(save_path, FileAccess.READ)
		
		game_data = save_file.get_var()
		save_file = null

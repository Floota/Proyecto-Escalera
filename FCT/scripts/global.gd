extends Node

#Declarar sqlmanager
const SQLManager = preload("res://scripts/SQLManager.gd")
var sql_manager: SQLManager

var collected_pickups = {}
var config_path = "user://ajustes.json"
var game_data : Dictionary
var collect_items : Dictionary
var collect_enemy : Dictionary
var player_position : Vector2 = Vector2.ZERO
#Puntuacion
var score : int = 0
#Frutas
var fruit: int = 0
var fruitSpecial: int = 0
#Tiempo total
var time: int = 240
#Vida
var health: float = 3

var current_npc_id = null

func _ready():
	load_config()
	
#Inicializar la base de datos y actualizar
	sql_manager = SQLManager.new()
	add_child(sql_manager)
	sql_manager._ready()
	
func load_config():
	if FileAccess.file_exists(config_path):
		var config_file = FileAccess.open(config_path, FileAccess.READ)
		var json_text = config_file.get_as_text()
		config_file.close()
		
		var json : JSON = JSON.new()
		var result = json.parse(json_text)
		
		if result == OK:
			var config_data = json.data
			if typeof(config_data) == TYPE_ARRAY and config_data.size() > 0:
				var config = config_data[0]
				if config.has("Resolucion"):
					var resolution_str = config["Resolucion"]
					var parts = resolution_str.split("x")
					if parts.size() == 2:
						var resolution = Vector2(int(parts[0]), int(parts[1]))
						print("Resolución cargada:", resolution)
						DisplayServer.window_set_size(resolution)
					else:
						print("Error: La resolución no tiene el formato correcto.")
				else:
					print("Error: La configuración no contiene una resolución válida.")
				
				if config.has("DisplayMode"):
					var display_mode = config["DisplayMode"]
					if display_mode == "FullScreen":
						DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
					elif display_mode == "Windowed":
						DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
					else:
						print("Error: El modo de pantalla no es válido.")
				else:
					print("Error: La configuración no contiene un modo de pantalla válido.")
			else:
				print("Error: El archivo de configuración no tiene el formato correcto.")
		else:
			print("Error al analizar JSON de configuración:", json.get_error_message())
	else:
		print("Error: No se encontró el archivo de configuración en:", config_path)	
		
func new_game() -> Dictionary: 
	print("Creando nuevo juego...")
	GLOBAL.reset_game_state()
	
	game_data = {
		"score" : 0,
		"health" : 3,
		"fruit" : 0,
		"time" : 240,
		"fruitSpecial" : 0,
		"player_position" : Vector2(133.0, 184.0)
	}

	get_tree().change_scene_to_file("res://assets/scenes/level/escena_juego.tscn")
	return game_data


func save_game(id_save:int):
	print("Guardando juego...")

	print("Datos del juego a guardar:", game_data)
	
	game_data["score"] = score
	game_data["health"] = health
	game_data["player_position"] = player_position
	game_data["time"] = time
	game_data["fruit"] = fruit
	game_data["fruitSpecial"] = fruitSpecial
	
	sql_manager.save_game_state(game_data, id_save)
	print("Datos del juego guardados:", game_data)

	
func reset_game_state():
	print("Restableciendo el estado del juego...")
	score = 0
	health = 3
	time = 240
	fruit = 0
	fruitSpecial = 0
	player_position = Vector2(133, 184)
	
	

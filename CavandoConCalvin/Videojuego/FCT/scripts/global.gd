extends Node
#Declarar sqlmanager
const SQLManager = preload("res://scripts/SQLManager.gd")
var sql_manager: SQLManager


#Recolectar objetos y enemigos
var collected_disappear = {}
var path_disappear = "user://disappear.json"

#Npcs
var collected_disappear_npc = {}
var path_disappear_npc = "user://collected_npc.json"

#Ajustes y los datos del jugador
var config_path = "user://ajustes.json"
var game_data : Dictionary

#Posicion
var player_position : Vector2 = Vector2.ZERO
#Puntuacion
var score : int = 0
#Frutas
var fruit: int = 0
var fruitSpecial: int = 0
#Tiempo total
var time: int = 180
#Vida
var health: float = 3

#ID NPC y ranura en la que esta el jugador
var current_npc_id = null
var slot_load : int 
func _ready():
	load_config()
	
#Inicializar la base de datos y actualizar
	sql_manager = SQLManager.new()
	add_child(sql_manager)
	sql_manager._ready()
	
#Cargar configuracion
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
				
				if config.has("DisplayMode"):
					var display_mode = config["DisplayMode"]
					if display_mode == "FullScreen":
						DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
					elif display_mode == "Windowed":
						DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
					else:
						print("Error modo pantalla.")
#Nueva partida
func new_game() -> Dictionary: 
	GLOBAL.reset_game_state()
	
	game_data = {
		"score" : 0,
		"health" : 3,
		"fruit" : 0,
		"time" : 180,
		"fruitSpecial" : 0,
		"player_position" : Vector2(133.0, 184.0)
	}
	get_tree().change_scene_to_file("res://assets/scenes/level/escena_juego.tscn")
	return game_data
#Resetear
func reset_game_state():
	score = 0
	health = 3
	time = 180
	fruit = 0
	fruitSpecial = 0
	player_position = Vector2(133, 184)
	collected_disappear = {}
	collected_disappear_npc = {}

#Guardar coleccionables
func save_collect(id_slot: int):
	var disappear = {}
	var disappear_npc = {}
	
	#Cargar datos existentes si el archivo existe
	if FileAccess.file_exists(path_disappear):
		var file = FileAccess.open(path_disappear, FileAccess.READ)
		var json_text = file.get_as_text()
		file.close()

		var json = JSON.new()
		var result = json.parse(json_text)

		if result == OK:
			disappear = json.data
	
	if FileAccess.file_exists(path_disappear_npc):
		var file_npc = FileAccess.open(path_disappear_npc, FileAccess.READ)
		var json_text_npc = file_npc.get_as_text()
		file_npc.close()

		var json_npc = JSON.new()
		var result_npc = json_npc.parse(json_text_npc)

		if result_npc == OK:
			disappear_npc = json_npc.data

	var slot_key = str(id_slot)
	disappear[slot_key] = {"collected_disappear": collected_disappear}
	disappear_npc[slot_key] = {"collected_disappear_npc": collected_disappear_npc}

	#Guardar datos en archivos JSON separados
	var file = FileAccess.open(path_disappear, FileAccess.WRITE)
	var file_npc = FileAccess.open(path_disappear_npc, FileAccess.WRITE)

	file.store_string(JSON.stringify(disappear))
	file_npc.store_string(JSON.stringify(disappear_npc))

	file.close()
	file_npc.close()
	print("Estado del juego guardado en la ranura", slot_key)

func load_collect(id_slot: int):
	var disappear = {}
	var disappear_npc = {}

	if FileAccess.file_exists(path_disappear):
		var file = FileAccess.open(path_disappear, FileAccess.READ)
		var json_text = file.get_as_text()
		file.close()
		var json = JSON.new()
		var result = json.parse(json_text)

		if result == OK:
			disappear = json.data
			var slot_key = str(id_slot)
			if disappear.has(slot_key):
				collected_disappear = disappear[slot_key].get("collected_disappear", {})
				print("Estado del juego cargado desde la ranura", slot_key)
			else:
				print("No hay datos guardados para la ranura", slot_key)

	if FileAccess.file_exists(path_disappear_npc):
		var file_npc = FileAccess.open(path_disappear_npc, FileAccess.READ)
		var json_text_npc = file_npc.get_as_text()
		file_npc.close()
		var json_npc = JSON.new()
		var result_npc = json_npc.parse(json_text_npc)

		if result_npc == OK:
			disappear_npc = json_npc.data
			var slot_key = str(id_slot)
			if disappear_npc.has(slot_key):
				collected_disappear_npc = disappear_npc[slot_key].get("collected_disappear_npc", {})
				print("Estado del juego de NPCs cargado desde la ranura", slot_key)
			else:
				print("No hay datos de NPCs guardados para la ranura", slot_key)
		
func delete_save(id_slot: int):
	var disappear = {}
	var disappear_npc = {}

	if FileAccess.file_exists(path_disappear):
		var file = FileAccess.open(path_disappear, FileAccess.READ)
		var json_text = file.get_as_text()
		file.close()
		var json = JSON.new()
		var result = json.parse(json_text)

		if result == OK:
			disappear = json.data
			var slot_key = str(id_slot)

			if disappear.has(slot_key):
				disappear.erase(slot_key)
				print("Datos de la ranura", slot_key, "eliminados exitosamente.")
			else:
				print("No hay datos guardados para la ranura", slot_key)

			#Guardar los datos actualizados en el archivo JSON
			file = FileAccess.open(path_disappear, FileAccess.WRITE)
			file.store_string(JSON.stringify(disappear))
			file.close()
			print("Datos actualizados guardados en el archivo", path_disappear)

	if FileAccess.file_exists(path_disappear_npc):
		var file_npc = FileAccess.open(path_disappear_npc, FileAccess.READ)
		var json_text_npc = file_npc.get_as_text()
		file_npc.close()
		var json_npc = JSON.new()
		var result_npc = json_npc.parse(json_text_npc)

		if result_npc == OK:
			disappear_npc = json_npc.data

			var slot_key_npc = str(id_slot)

			if disappear_npc.has(slot_key_npc):
				disappear_npc.erase(slot_key_npc)
				print("Datos de la ranura NPC", slot_key_npc, "eliminados exitosamente.")
			else:
				print("No hay datos de NPCs guardados para la ranura", slot_key_npc)

			file_npc = FileAccess.open(path_disappear_npc, FileAccess.WRITE)
			file_npc.store_string(JSON.stringify(disappear_npc))
			file_npc.close()
			print("Datos de NPCs actualizados guardados en el archivo",path_disappear_npc)

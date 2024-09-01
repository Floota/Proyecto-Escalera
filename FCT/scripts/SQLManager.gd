extends Node

var database : SQLite

func _ready():
	database = SQLite.new()
	database.path = "res://game_data.db"
#Crea el archivo si no existe
	if not database.open_db():
		print("Error al abrir la base de datos.")
		return
		
#Crear tabla ranking
	var create_table_query = """
	CREATE TABLE IF NOT EXISTS ranking_game 
	(id_player INTEGER PRIMARY KEY AUTOINCREMENT, 
	name_player TEXT, 
	score_player INTEGER
	)"""
	
	if not database.query(create_table_query):
		print("Error al crear la tabla.")
		
	# Crear tabla para guardar partida
	var create_save_table_query = """
	CREATE TABLE IF NOT EXISTS game_save (
		id_save INTEGER PRIMARY KEY AUTOINCREMENT,
		score INTEGER,
		health REAL,
		player_position_x REAL,
		player_position_y REAL,
		time INTEGER,
		fruit INTEGER,
		fruitSpecial INTEGER
	)"""
	if not database.query(create_save_table_query):
		print("Error al crear la tabla game_save.")
		
#Insertar filas
func save_score(name: String, score: int):
	print("Guardando puntaje:", name, score)
	var query = "INSERT INTO ranking_game (name_player, score_player) VALUES ('%s', %d)" % [name, score]
	print("Consulta SQL:", query)
	var result = database.query(query)
	if not result:
		print("Error al insertar el puntaje.")
	else:
		print("Puntaje insertado correctamente.")

#Consulta SELECT
func load_scores() -> Array:
	print("Ejecutando consulta SQL...")
	var scores = []
	var query = "SELECT name_player, score_player FROM ranking_game ORDER BY score_player DESC LIMIT 5"
	print("Consulta SQL:", query)
	var result = database.query(query)
	
	#Verificar errores en consulta
	if not result:
		print("Error al ejecutar la consulta de selección: ")
		return scores

	#Obtener los resultados de la consulta
	var query_result = database.get_query_result()
	print("Resultados de la consulta:", query_result)

	#Aregarlos a la lista de puntuaciones
	for row in query_result:
		var entry = {
			"name_player": row["name_player"],
			"score_player": row["score_player"]
		}
		scores.append(entry)

	return scores
	
#Recoger datos guardados
func get_saved_games() -> Array:
	print("Ejecutando consulta SQL...")
	var saved_games = []

	#Consultar todas las partidas guardadas
	var query = "SELECT * FROM game_save ORDER BY id_save ASC"
	print("Consulta SQL:", query)
	var result = database.query(query)
	if not result:
		print("Error al obtener las partidas guardadas.")
		return saved_games

	#Procesar los resultados de la consulta
	var query_result = database.get_query_result()
	for row in query_result:
		var game_data = {
			"id_save": row["id_save"],
			"score": row["score"],
			"health": row["health"],
			"player_position": Vector2(row["player_position_x"], row["player_position_y"]),
			"time": row["time"],
			"fruit": row["fruit"],
			"fruitSpecial": row["fruitSpecial"]
		}
		saved_games.append(game_data)
		print("Resultados de la consulta:", query_result)
	return saved_games
	
#Limpiar ranking
func clear_container(container: VBoxContainer):
	while container.get_child_count() > 0:
		var child = container.get_child(0)
		container.remove_child(child)
		child.queue_free()

#Actualizar 
func update_ranking_display(container: VBoxContainer):
	print("actualizando ranking")
	# Cargar las puntuaciones del ranking
	var scores = load_scores()

	# Verificar si se cargaron puntajes
	print("Puntuaciones cargadas:", scores)

	# Limpiar el contenedor antes de agregar nuevos puntajes
	clear_container(container)
	 # Crear una nueva fuente con FontFile y configurar el tamaño
	var font_file = "res://assets/scenes/gui/PixeloidMono.otf"
	
	for score in scores:
		var score_label = Label.new()
		score_label.text = "%s: %d" % [score["name_player"], score["score_player"]]
		score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		score_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

		container.add_child(score_label)
		
#Guardar juego segun id
func save_game_state(game_data: Dictionary, id_save: int):
	
	print("Guardando estado del juego:")
	print("ID del Slot:", id_save)
	print("Datos del juego:", game_data)
	
	var query = "INSERT INTO game_save (id_save, score, health, player_position_x, player_position_y, time, fruit, fruitSpecial) VALUES (%d, %d, %f, %f, %f, %d, %d, %d)" % [
		id_save,
		game_data["score"],
		game_data["health"],
		game_data["player_position"].x,
		game_data["player_position"].y,
		game_data["time"],
		game_data["fruit"],
		game_data["fruitSpecial"],
		
	]
	if not database.query(query):
		print("Error al guardar el estado del juego.")
	else:
		print("Estado del juego guardado correctamente.")
		
	
#Cargar segun id
func load_game_state(id_save: int) -> Dictionary:
	var game_data = {}
	var query = "SELECT * FROM game_save WHERE id_save = %d" % id_save
	if not database.query(query):
		print("Error al cargar el estado del juego.")
		return {}
	
	var query_result = database.get_query_result()
	if query_result.size() == 0:
		print("No hay datos de guardado disponibles para el ID:", id_save)
		return {}
	
	var row = query_result[0]
	game_data["score"] = row["score"]
	game_data["health"] = row["health"]
	game_data["player_position"] = Vector2(row["player_position_x"], row["player_position_y"])
	game_data["time"] = row["time"]
	game_data["fruit"] = row["fruit"]
	game_data["fruitSpecial"] = row["fruitSpecial"]
	
	return game_data
	
#Actualizar tabla con partida guardada
func update_game_state(game_data: Dictionary, id_save: int) -> bool:
	var query = "UPDATE game_save SET score = %d, health = %f, player_position_x = %f, player_position_y = %f, time = %d, fruit = %d, fruitSpecial = %d WHERE id_save = %d" % [
		game_data["score"],
		game_data["health"],
		game_data["player_position"].x,
		game_data["player_position"].y,
		game_data["time"],
		game_data["fruit"],
		game_data["fruitSpecial"],
		id_save
	]
	var result = database.query(query)
	if not result:
		print("Error al actualizar el estado del juego.")
		return false
	else:
		print("Estado del juego actualizado correctamente.")
		return true

#Borrar ranura de partida guardada
func delete_game_state(slot_number):
	var query = "DELETE FROM game_save WHERE id_save = %d" % slot_number
	var result = database.query(query)
	if not result:
		print("Error al borrar el juego.")
		return false
	else:
		print("Borrado correctamente.")
		return true
	
func close():
	database.close()

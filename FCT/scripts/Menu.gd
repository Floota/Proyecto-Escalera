extends Control

#Declarar sqlmanager
const SQLManager = preload("res://scripts/SQLManager.gd")
var sql_manager: SQLManager
var list_buttons

func _ready():
	print("Menu principal listo.")
	$LoadOptions.visible = false
	list_buttons = [
	  	$LoadOptions/Load1,
		$LoadOptions/Load2,
		$LoadOptions/Load3
	]
	$Botones/Iniciar.grab_focus()
#Inicializar la base de datos
	sql_manager = SQLManager.new()
	add_child(sql_manager)
	sql_manager._ready()
	sql_manager.update_ranking_display($Ranking/ListaJugadores)
	update_load_buttons()

#Iniciar nuevo juego
func _on_iniciar_pressed():
	print("Botón 'Iniciar' presionado.")
	GLOBAL.new_game()
	print("Nuevo juego creado.")

#Salir juego
func _on_salir_pressed():
	print("Botón 'Salir' presionado.")
	get_tree().quit()

#Cargar contenedor partidas
func _on_cargar_pressed():
	print("Botón 'Cargar' presionado.")
	$LoadOptions.visible = true

#Actializar botones
func update_load_buttons():
	var saved_games = sql_manager.get_saved_games()
	print("Juegos guardados obtenidos:", saved_games)
	
	for i in range(3):
		var button = list_buttons[i]
		var slot_id = i + 1
		var game_data = null

		# Buscar los datos del juego correspondiente al slot_id
		for game in saved_games:
			if game["id_save"] == slot_id:
				game_data = game
				break
		
		if game_data:
			button.text = "Ranura %d: Puntos: %d, Frutas: %d, Tiempo: %d" % [
				slot_id,  
				game_data["score"],  
				game_data["fruit"],  
				game_data["time"]  
			]
			button.disabled = false
		else:
			button.text = "Ranura %d: Vacío" % slot_id
			button.disabled = false

#Cargar partida guardada
func load_slot(slot_number):
	print("Cargando partida en el Slot:", slot_number)
	var game_data = sql_manager.load_game_state(slot_number)
	if game_data.size() > 0:
		print("Partida cargada:", game_data)
		# Actualizar el estado del juego con los datos de la partida cargada
		GLOBAL.score = game_data["score"]
		GLOBAL.health = game_data["health"]
		GLOBAL.time = game_data["time"]
		GLOBAL.fruit = game_data["fruit"]
		GLOBAL.fruitSpecial = game_data["fruitSpecial"]
		GLOBAL.player_position = game_data["player_position"]
		
		# Cambiar a la escena del juego
		get_tree().change_scene_to_file("res://assets/scenes/level/escena_juego.tscn")
	else:
		print("No hay partida guardada en el Slot", slot_number)
	

func _on_load_1_pressed():
	load_slot(1)

func _on_load_2_pressed():
	load_slot(2)

func _on_load_3_pressed():
	load_slot(3)

extends CanvasLayer
var is_paused: bool = false
var player
const SQLManager = preload("res://scripts/SQLManager.gd")
var sql_manager: SQLManager
var list_buttons
var game_data
var id_slot

func _ready():
	list_buttons = [
	  	$ColorRect/SaveOptions/Slot1,
		$ColorRect/SaveOptions/Slot2,
		$ColorRect/SaveOptions/Slot3
	]
	set_is_paused(false)
	$ColorRect/SaveOptions.visible = false
	$ColorRect/OptionsSlot.visible = false
	player = get_tree().get_nodes_in_group("player")[0] 
	
	#Inicializar la base de datos y actualizar botones
	sql_manager = SQLManager.new()
	add_child(sql_manager)
	sql_manager._ready()
	update_save_buttons()
	
func set_is_paused(value):
	is_paused=value
	get_tree().paused=is_paused
	visible=is_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause_game"):
		set_is_paused(!is_paused)
		
#Volver al juego
func _on_resume_pressed():
	set_is_paused(false)
	
#Ir a contenedor partidas
func _on_save_pressed():
	GLOBAL.player_position = player.position
	$ColorRect/SaveOptions.visible = true

#Salir al menu principal
func _on_exit_pressed():
	set_is_paused(false)
	print("Regresando al menú principal desde el menú de pausa...")
	get_tree().change_scene_to_file("res://assets/scenes/gui/menu.tscn")

#Actualizar botones
func update_save_buttons():
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

#Guardado dependiendo de la ranura
func slot_pressed(slot_number):
	id_slot = slot_number
	print("Guardando partida en el Slot:", slot_number)
	game_data = {
		"score": GLOBAL.score,
		"health": GLOBAL.health,
		"player_position": GLOBAL.player_position,
		"time": GLOBAL.time,
		"fruit": GLOBAL.fruit,
		"fruitSpecial": GLOBAL.fruitSpecial
	}

	#Verificar si la ranura estavacia
	var existing_game_data = sql_manager.load_game_state(slot_number)
	if existing_game_data.size() > 0:
		var empty_slot = true
		for field in existing_game_data.values():
			if field != 0: 
				empty_slot = false
				break

		if empty_slot:
			print("El slot está vacío. Guardando una nueva partida.")
			sql_manager.save_game_state(game_data, slot_number)
		else:
			$ColorRect/OptionsSlot.visible = true
			
	else:
		print("El slot está vacío. Guardando una nueva partida.")
		sql_manager.save_game_state(game_data, slot_number)

	#Actualizar los botones alguardar la partida
	update_save_buttons()
	
func _on_slot_1_pressed():
	slot_pressed(1)
	
func _on_slot_2_pressed():
	slot_pressed(2)
	
func _on_slot_3_pressed():
	slot_pressed(3)
	
func _on_update_pressed():
	sql_manager.update_game_state(game_data, id_slot)
	update_save_buttons()
	$ColorRect/OptionsSlot.visible = false
	
func _on_delete_pressed():
	sql_manager.delete_game_state(id_slot)
	update_save_buttons()
	$ColorRect/OptionsSlot.visible = false

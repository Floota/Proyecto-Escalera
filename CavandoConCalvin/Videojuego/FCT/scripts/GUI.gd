extends CanvasLayer

class_name GUI

var fruitCheckVar = GLOBAL.fruit
#Declarar la variable sql_manager para conectar
const SQLManager = preload("res://scripts/SQLManager.gd")
var sql_manager: SQLManager
var end_player : bool = false
var win_player : bool = false
@onready var container_life = $ContainerLife
@onready var container_fruit = $ContainerFruit
@onready var container_name = $GameOver/VBoxContainer3/TextEdit 
@onready var restart_button = $GameOver/VBoxContainer2/Restart
@onready var exit_button = $GameOver/VBoxContainer2/Exit 
@onready var container_name_win = $PartidaGanada/VBoxContainerW/TextEdit
@onready var restart_button_win = $PartidaGanada/VBoxContainerW2/Restart
@onready var exit_button_win = $PartidaGanada/VBoxContainerW2/Exit

func _ready():
	intro()
	$GameOver.visible = false
	$PartidaGanada.visible = false
	update_fruit_display()
	

#Inicializar la base de datos y actualizar
	sql_manager = SQLManager.new()
	add_child(sql_manager)
	sql_manager._ready()
	sql_manager.update_ranking_display($GameOver/Ranking/ListaJugadores)
	sql_manager.update_ranking_display($PartidaGanada/Ranking/ListaJugadores)
	
	
func _process(delta):
	update_fruit_display()
	update_health_display(GLOBAL.health)
	
func _physics_process(_delta):
#Mostrar datos en pantalla
	$ContainerTime/TimeP.text = str(GLOBAL.time)
	$ContainerScore/ScoreP.text = str(GLOBAL.score)
	$ContainerFruit/Label.text = str(GLOBAL.fruit)

#Actualizar tiempo
func time_ctrl_update():
	GLOBAL.time -= 1
	$ContainerTime/TimeP.text = str(GLOBAL.time)
	if GLOBAL.time <= 0:
		if GLOBAL.fruit >= 15:
			win_player = true
			win_game()
		elif GLOBAL.fruit < 15:
			end_player = true
			game_over()
	elif GLOBAL.fruit >= 15 and GLOBAL.time >= 0:
		win_player = true
		win_game()

#Actualizar frutas
func update_fruit_display():
	if fruitCheckVar != GLOBAL.fruit:
		var tween = create_tween()
		$ContainerFruit.visible = true
		tween.tween_property(container_fruit, "position", Vector2(8.0, 32.0), 1.0)
		tween.tween_interval(2.0)
		tween.tween_property(container_fruit, "position", Vector2(-100.0, 32.0), 1.0)
		fruitCheckVar = GLOBAL.fruit

#Actualizar corazones
func update_health_display(health):
	var full_hearts = floor(health)  #Obtener la parte entera de la vida
	var half_heart = health - full_hearts  
	
	#Configurar las vidas completas
	$ContainerLife/Heart0.texture = load("res://assets/textures/heart_empty.png")
	$ContainerLife/Heart1.texture = load("res://assets/textures/heart_empty.png")
	$ContainerLife/Heart2.texture = load("res://assets/textures/heart_empty.png")

	for i in range(full_hearts):
		match i:
			0:
				$ContainerLife/Heart0.texture = load("res://assets/textures/heart_full.png")
			1:
				$ContainerLife/Heart1.texture = load("res://assets/textures/heart_full.png")
			2:
				$ContainerLife/Heart2.texture = load("res://assets/textures/heart_full.png")


	if full_hearts == 2:  #Si hay dos corazones llenos
		if half_heart >= 0.5:  #Si hay al menos la mitad de un corazón
			$ContainerLife/Heart2.texture = load("res://assets/textures/heart_half.png")
		elif half_heart > 0: 
			$ContainerLife/Heart2.texture = load("res://assets/textures/heart_empty.png")  
	elif full_hearts == 1:  #Si hay un corazón lleno
		if half_heart >= 0.5:  
			$ContainerLife/Heart1.texture = load("res://assets/textures/heart_half.png")
		elif half_heart > 0:  
			$ContainerLife/Heart1.texture = load("res://assets/textures/heart_empty.png")  
	elif full_hearts == 0:  #Si no hay corazones llenos
		if half_heart >= 0.5: 
			$ContainerLife/Heart0.texture = load("res://assets/textures/heart_half.png")
		elif half_heart > 0:  
			$ContainerLife/Heart0.texture = load("res://assets/textures/heart_empty.png")  

#GameOver
func game_over() -> void:
	end_player = true
	$GameOver.visible = true
	get_tree().paused = true
	$GameOver/VBoxContainer2/Restart.grab_focus()
	sql_manager.delete_game_state(GLOBAL.slot_load)
	GLOBAL.delete_save(GLOBAL.slot_load)
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property($GameOver, "modulate", Color(1, 1, 1, 0.8), 1.0)
	
#Ganar partida
func win_game() -> void:
	$PartidaGanada.visible = true
	get_tree().paused = true
	$PartidaGanada/VBoxContainerW2/Restart.grab_focus()
	sql_manager.delete_game_state(GLOBAL.slot_load)
	GLOBAL.delete_save(GLOBAL.slot_load)
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property($PartidaGanada, "modulate", Color(1, 1, 1, 0.8), 1.0)
	
#Conexion tiempo actualizar
func _on_timer_timeout():
	time_ctrl_update()
	
func _on_save_name_pressed():
	if end_player:
		var player_name = container_name.text.strip_edges()
		if player_name != "":
			#Guardar la puntuación y el nombre del jugador
			sql_manager.save_score(player_name, GLOBAL.score)
			$GameOver/VBoxContainer3/SaveName.disabled = true

	elif win_player:
		var player_name = container_name_win.text.strip_edges()
		if player_name != "":
			#Guardar la puntuación y el nombre del jugador
			sql_manager.save_score(player_name, GLOBAL.score)
			$PartidaGanada/VBoxContainerW/SaveName.disable = true
		else:
			print("Se necesita texto")

	else:
		print("que")	
	sql_manager.update_ranking_display($GameOver/Ranking/ListaJugadores)
	sql_manager.update_ranking_display($PartidaGanada/Ranking/ListaJugadores)
	
	
func _on_restart_pressed():
	print("Boton de reinicio")
	get_tree().paused = false
	$GameOver.visible = false
	$PartidaGanada.visible = false
	GLOBAL.new_game()

func intro():
	var tween = create_tween()
	tween.tween_property($IntroCircle, "scale", Vector2(), 1.5)

func _on_exit_pressed():
	get_tree().paused = false
	$PartidaGanada.visible = false
	$GameOver.visible = false
	print("Regresando al menú principal desde el menú de pausa...")
	get_tree().change_scene_to_file("res://assets/scenes/gui/menu.tscn")


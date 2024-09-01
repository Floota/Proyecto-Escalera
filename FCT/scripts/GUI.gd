extends CanvasLayer

var fruitCheckVar = GLOBAL.fruit
#Declarar la variable sql_manager para conectar
const SQLManager = preload("res://scripts/SQLManager.gd")
var sql_manager: SQLManager

@onready var container_life = $ContainerLife
@onready var container_fruit = $ContainerFruit
@onready var container_name = $GameOver/VBoxContainer3/TextEdit
@onready var restart_button = $GameOver/VBoxContainer2/Restart
@onready var exit_button = $GameOver/VBoxContainer2/Exit

func _ready():
	intro()
	$GameOver.visible = false
	update_health_display(GLOBAL.health)
	update_fruit_display()
	
	restart_button.disabled = true
	exit_button.disabled = true
	
#Inicializar la base de datos y actualizar
	sql_manager = SQLManager.new()
	add_child(sql_manager)
	sql_manager._ready()
	sql_manager.update_ranking_display($GameOver/Ranking/ListaJugadores)
	
func _process(delta):
	update_fruit_display()
	
func _physics_process(_delta):
#Mostrar datos en pantalla
	$ContainerTime/TimeP.text = str(GLOBAL.time)
	$ContainerScore/ScoreP.text = str(GLOBAL.score)
	$ContainerFruit/Label.text = str(GLOBAL.fruit)

#Actualizar tiempo
func time_ctrl_update():
	GLOBAL.time -= 1
	$ContainerTime/TimeP.text = str(GLOBAL.time)
	if GLOBAL.time == 0:
		game_over()

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
	print("Actualizando la visualización de la salud con la salud:", health)
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
	$GameOver.visible = true
	get_tree().paused = true
	$GameOver/VBoxContainer2/Restart.grab_focus()
	
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property($GameOver, "modulate", Color(1, 1, 1, 0.8), 1.0)
	
#Conexion tiempo actualizar
func _on_timer_timeout():
	time_ctrl_update()
	
func _on_save_name_pressed():
	
	var player_name = container_name.text.strip_edges()
	if player_name != "":
		#Guardar la puntuación y el nombre del jugador
		sql_manager.save_score(player_name, GLOBAL.score)
		restart_button.disabled = false
		exit_button.disabled = false
	sql_manager.update_ranking_display($GameOver/Ranking/ListaJugadores)

func _on_restart_pressed():
	print("Botón de reinicio presionado")
	get_tree().paused = false
	$GameOver.visible = false
	GLOBAL.new_game()

func intro():
	var tween = create_tween()
	tween.tween_property($IntroCircle, "scale", Vector2(), 1.5)

func _on_exit_pressed():
	get_tree().paused = false
	$GameOver.visible = false
	print("Regresando al menú principal desde el menú de pausa...")
	get_tree().change_scene_to_file("res://assets/scenes/gui/menu.tscn")

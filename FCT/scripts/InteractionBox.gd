extends Control

var dialog_index
var current_npc
var tween : Tween
@onready var richLabel = $RichTextLabel
@onready var option_container = $ColorRect
@onready var option_yes = $ColorRect/VBoxContainer/HBoxContainer/Si
@onready var option_no = $ColorRect/VBoxContainer/HBoxContainer/No

var special_fruits_given_1 = false
var special_fruits_given_2 = false
var special_fruits_given_3 = false

const dialogs_npc = {
	
	0: [
		"Pero bueeeeeno como tu por aqui!", 
		"No querras entrar a las cuevas! Es muy peligroso!",
		"En fin, si no hay mas remedio, te dare un regalo que seguro que te viene muy bien en tu aventura",
		"Date prisa que llega el invierno",
	],
	1:[
		"Calvin! Menos mal que te encuentro!",
		"Ahi dentro pasa algo, pero tengo mucha hambre y no me puedo mover",
		"¿Tendrias para darme 2 frutas especiales?"
	],
	2:[
		"Ay! Mi querido Calvin ¡como has crecido!",
		"Estoy buscando de esas frutas tan sabrosas",
		"Soy ya mayor y no veo bien, ¿Podrias traer a tu abuela un par de frutas especiales?"
	],
	3:[
		"Blablablablabla!",
		"Blablablablabla!",
		"Blablablablabla!",
		"¿Tendrias para darme 3 frutas especiales?"
	],
}

func _ready():
	visible = false
	option_container.visible = false

func start(npc_id):
	visible = true
	dialog_index = 0
	current_npc = npc_id
	speak()
	
func stop():
	visible = false
	dialog_index = 0
	current_npc = null
	

func speak():
	richLabel.visible_ratio = 0
	richLabel.text = dialogs_npc[current_npc][dialog_index]
	tween = create_tween()
	tween.tween_property(richLabel, "visible_ratio", 1, 1)
	dialog_index += 1

func next():
	if(dialog_index < dialogs_npc[current_npc].size()):
		speak()
	else:
		if current_npc in [1, 2, 3] and not (special_fruits_given_1 or special_fruits_given_2 or special_fruits_given_3):
			option_container.visible = true
		else:
			visible = false
		
func _input(event):
	if event.is_action_released("interaction") and visible and not option_container.visible:
		next()
		
func offer_fruits():
	var player = get_tree().get_nodes_in_group("player")[0]
	var required_fruits = 0
	var success_message = ""
	
	if current_npc == 1:
		required_fruits = 2
		success_message = "¡Gracias por las frutas especiales! Ahora puedo moverme. ¡Puedes pasar!"
		special_fruits_given_1 = true
	elif current_npc == 2:
		required_fruits = 2
		success_message = "¡Gracias por las frutas especiales! ¡Eres un amor!"
		special_fruits_given_2 = true
	elif current_npc == 3:
		required_fruits = 3
		success_message = "¡Gracias por las frutas especiales! ¡Ahora puedo seguir adelante!"
		special_fruits_given_3 = true

	if GLOBAL.fruitSpecial >= required_fruits:
		GLOBAL.fruitSpecial -= required_fruits
		richLabel.text = success_message
	else:
		richLabel.text = "No tienes suficientes frutas especiales. Vuelve cuando las consigas."

	dialog_index = 0
	tween = create_tween()
	tween.tween_property(richLabel, "visible_ratio", 1, 1)

func _on_si_pressed():
	option_container.visible = false
	offer_fruits()

func _on_no_pressed():
	option_container.visible = false
	richLabel.text = "Vuelve cuando quieras."
	dialog_index = 0
	tween = create_tween()
	tween.tween_property(richLabel, "visible_ratio", 1, 1)

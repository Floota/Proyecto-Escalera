extends Control
class_name InteractionBox


var dialog_index
var current_npc
var tween : Tween
var end_dialog
var name_npc
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
		"Date prisa que llega el invierno", 
		"Necesitaras al menos 15 frutas, y recuerda...",
		"Hay personas por ahi que quizas te ayuden",
		"Incluso vi zonas ocultas por si te sirve de ayuda",
		"Buena suerte!"
	],
	1:[
		"Calvin! Menos mal que te encuentro!",
		"Ahi dentro pasa algo, pero tengo mucha hambre y no me puedo mover",
		"¿Tendrias para darme 2 frutas especiales?"
	],
	2:[
		"Ay! Mi querido Calvin ¡como has crecido!",
		"Estoy buscando de esas frutas tan sabrosas",
		"Soy ya mayor y no veo bien, ¿Podrias traer a tu abuela un par de frutas especiales?",
		"Te dare mas tiempo si me las das!"
	],
	3:[
		"Hola muchacho, mi nombre es Zacarias III de Toposlavia",
		"Veo que necesitas comida para sobrevivir el invierno",
		"¿Que te parece si a cambio de tiempo te doy unas frutas?"
	],
}

func _ready():
	visible = false
	option_container.visible = false

func start(npc_id):
	end_dialog = false
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
		if current_npc == 0:
			var npcs = get_tree().get_nodes_in_group("NPC")
			for npc in npcs:
				if npc.has_method("get_npc_id") and npc.get_npc_id() == 0:
					npc.collision_shape.disabled = true
					name_npc = npc.name
					GLOBAL.collected_disappear_npc[name_npc] = true
					print(name_npc)
					break
		# Verificar si el NPC es 1, 2 o 3 y si ya se han dado las frutas especiales
		print(current_npc)
		if (current_npc == 1 and not special_fruits_given_1) or (current_npc == 2 and not special_fruits_given_2) or (current_npc == 3 and not special_fruits_given_3):
			print(current_npc)
			option_container.visible = true
		else:
			self.visible = false  # Oculta el cuadro de diálogo
			option_container.visible = false
		
func _input(event):
	if event.is_action_released("interaction") and visible and not option_container.visible:
		if end_dialog:
			stop()
		else:
			next()	
		
func offer_fruits():
	
	var player = get_tree().get_nodes_in_group("player")[0]
	var required_fruits = 0
	var success_message = ""
	
	if current_npc == 1:
		name_npc = current_npc
		required_fruits = 2
		success_message = "¡Muchas gracias! Ahora puedo moverme. ¡Puedes pasar!"
		special_fruits_given_1 = true
		
	elif current_npc == 2:
		name_npc = current_npc
		required_fruits = 2
		success_message = "Muy amable querido, toma te vendrá muy bien"
		GLOBAL.time += 20
		special_fruits_given_2 = true
		
	elif current_npc == 3:
		name_npc = current_npc
		success_message = "Espero que te ayuden estas frutas. ¡Un placer amigo!"
		GLOBAL.fruit += 5
		GLOBAL.time -= 15
		special_fruits_given_3 = true

	if GLOBAL.fruitSpecial >= required_fruits:
		GLOBAL.fruitSpecial -= required_fruits
		richLabel.text = success_message
		end_dialog = true
		if current_npc in [1,2,3]:
			#Acceder al NPC con npc_id == 1 y desactivar su colision
			var npcs = get_tree().get_nodes_in_group("NPC")
			for npc in npcs:
				#Comprueba si el npc tiene una propiedad npc_id y si es igual a 1
				if npc.has_method("get_npc_id") and npc.get_npc_id() == current_npc:
					npc.collision_shape.disabled = true #Desactiva la colision del NPC
					name_npc = npc.name
					GLOBAL.collected_disappear_npc[name_npc] = true
					dialog_index = 0
					break
					
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

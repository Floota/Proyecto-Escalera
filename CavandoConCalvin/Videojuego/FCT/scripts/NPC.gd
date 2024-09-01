extends CharacterBody2D

@export var npc_id = 3
@onready var collision_shape = $CollisionShape2D 
		
func _ready():
	var npcs = get_tree().get_nodes_in_group("NPC")
	for npc in npcs:
		if GLOBAL.collected_disappear_npc.has(npc.name):
			if npc.has_node("CollisionShape2D"):
				if npc.collision_shape:
					npc.collision_shape.disabled = true
				else:
					print("El nodo NPC", npc.name, "no tiene un CollisionShape2D inicializado.")

func get_npc_id():
	return npc_id

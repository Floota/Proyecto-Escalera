extends Area2D

class_name ItemManager

enum ItemType { TIME, HEALTH, SPECIAL_FRUIT, NORMAL_FRUIT }
@onready var audio_stream_player = $AudioStreamPlayer
@export var gui : CanvasLayer
var item_type: ItemType

const SCORE_TIME = 15
const SCORE_HEALTH = 50
const SCORE_SPECIAL_FRUIT = 200
const SCORE_NORMAL_FRUIT = 100

func _ready():
	if GLOBAL.collected_disappear.has(get_name()):
		queue_free()

func _on_body_entered(body):
	if body is Player:
		GLOBAL.collected_disappear[get_name()] = true
		self.visible = false
		$Collision.set_deferred("disabled", true)
		match item_type:
			ItemType.TIME:
				GLOBAL.time += SCORE_TIME
				audio_stream_player.play()
			ItemType.HEALTH:
				GLOBAL.health += 0.5
				body.collect_item_half_heart()
				audio_stream_player.play()
			ItemType.SPECIAL_FRUIT:
				GLOBAL.fruitSpecial += 1
				GLOBAL.score += SCORE_SPECIAL_FRUIT
				audio_stream_player.play()
			ItemType.NORMAL_FRUIT:
				GLOBAL.fruit += 1
				GLOBAL.score += SCORE_NORMAL_FRUIT
				audio_stream_player.play()

func _on_audio_stream_player_finished():
		queue_free()

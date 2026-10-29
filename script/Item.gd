extends Area2D

@export var item_id: String = ""
@export var item_name: String = "Item"
@export var score_value: int = 0

@onready var prompt: Label = $PromptLabel

var player_in_range := false

func _ready() -> void:
	prompt.hide()
	if item_id.is_empty():
		push_warning("Item '%s' belum punya item_id!" % name)
	# Kalau item ini sudah pernah diambil, jangan munculkan lagi
	if GameState.has_item(item_id):
		queue_free()
		return
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		prompt.show()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		prompt.hide()

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		GameState.collect_item(item_id, score_value)
		queue_free()

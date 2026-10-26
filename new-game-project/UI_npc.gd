extends Area2D

@export_multiline var dialog_text: String = "Halo, selamat datang!"

@onready var text_box: Control = $CanvasLayer/PanelContainer
@onready var label: Label = $CanvasLayer/PanelContainer/Label
@onready var prompt: Label = $PromptLabel

var player_in_range := false

func _ready() -> void:
	label.text = dialog_text
	text_box.hide()
	prompt.hide()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	# Animasi naik-turun pelan supaya prompt menarik perhatian
	var tween := create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	tween.tween_property(prompt, "position:y", prompt.position.y - 6, 0.5)
	tween.tween_property(prompt, "position:y", prompt.position.y, 0.5)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_in_range = true
		_update_prompt()

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_in_range = false
		text_box.hide()
		_update_prompt()

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		text_box.visible = not text_box.visible
		_update_prompt()

func _update_prompt() -> void:
	prompt.visible = player_in_range and not text_box.visible

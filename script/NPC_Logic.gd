extends Area2D

signal dialogue_started(npc_id: String)
signal dialogue_finished(npc_id: String)

@export var npc_id: String = ""
@export var npc_name: String = "NPC"
@export var dialog_lines: Array[String] = ["Halo!"]
@export var flag_after_talk: String = ""   # opsional, contoh: "bicara_mama"

@onready var prompt: Label = $PromptLabel
@onready var text_box: Control = $CanvasLayer/PanelContainer
@onready var text_label: Label = $CanvasLayer/PanelContainer/Label

var player_in_range := false
var talking := false
var line_index := 0

func _ready() -> void:
	prompt.hide()
	text_box.hide()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		prompt.visible = not talking

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		prompt.hide()
		if talking:
			_cancel_dialogue()

func _unhandled_input(event: InputEvent) -> void:
	if not player_in_range or not event.is_action_pressed("interact"):
		return
	get_viewport().set_input_as_handled()
	if talking:
		_next_line()
	else:
		_start_dialogue()

# --- Bagian ini yang nanti diganti teman (Dialogue Manager) ---
func _start_dialogue() -> void:
	if dialog_lines.is_empty():
		push_warning("NPC '%s' belum punya dialog_lines!" % name)
		return
	talking = true
	line_index = 0
	prompt.hide()
	text_box.show()
	_show_line()
	dialogue_started.emit(npc_id)

func _show_line() -> void:
	text_label.text = "%s: %s" % [npc_name, dialog_lines[line_index]]

func _next_line() -> void:
	line_index += 1
	if line_index >= dialog_lines.size():
		_end_dialogue()
	else:
		_show_line()
# -------------------------------------------------------------

func _end_dialogue() -> void:
	talking = false
	text_box.hide()
	prompt.visible = player_in_range
	if not flag_after_talk.is_empty():
		GameState.set_flag(flag_after_talk)
	dialogue_finished.emit(npc_id)

# Pemain menjauh di tengah dialog: tutup tanpa mencatat flag
func _cancel_dialogue() -> void:
	talking = false
	text_box.hide()

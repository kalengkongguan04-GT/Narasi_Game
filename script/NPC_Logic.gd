extends Area2D

signal dialogue_started(npc_id: String)
signal dialogue_finished(npc_id: String)

@export var npc_id: String = ""
@export var timeline_default: String = ""     # nama timeline biasa
@export var timeline_unlocked: String = ""    # timeline yang terbuka karena item
@export var required_item: String = ""        # ID item pembuka, contoh: "surat_rahasia"
@export var flag_after_talk: String = ""      # opsional

@onready var prompt: Label = $PromptLabel

var player_in_range := false
var talking := false

func _ready() -> void:
	prompt.hide()
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

func _unhandled_input(event: InputEvent) -> void:
	if talking or not player_in_range:
		return
	if event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		_start_dialogue()

func _pick_timeline() -> String:
	if not required_item.is_empty() and not timeline_unlocked.is_empty() \
			and GameState.has_item(required_item):
		return timeline_unlocked
	return timeline_default

func _start_dialogue() -> void:
	var timeline := _pick_timeline()
	if timeline.is_empty():
		push_warning("NPC '%s' belum punya timeline!" % name)
		return
	talking = true
	prompt.hide()
	Dialogic.timeline_ended.connect(_on_timeline_ended, CONNECT_ONE_SHOT)
	Dialogic.start(timeline)
	dialogue_started.emit(npc_id)

func _on_timeline_ended() -> void:
	talking = false
	prompt.visible = player_in_range
	if not flag_after_talk.is_empty():
		GameState.set_flag(flag_after_talk)
	dialogue_finished.emit(npc_id)

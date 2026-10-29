extends Area2D

@export_file("*.tscn") var target_scene: String = ""
@export var target_spawn: String = ""

@onready var prompt: Label = $PromptLabel

var player_in_range := false

func _ready() -> void:
	prompt.hide()
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
		if target_scene.is_empty():
			push_warning("Door '%s' belum punya target_scene!" % name)
			return
		player_in_range = false
		GameState.next_spawn = target_spawn
		SaveManager.save_game(target_scene)
		get_tree().change_scene_to_file.call_deferred(target_scene)

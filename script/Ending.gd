extends Area2D

@export_file("*.tscn") var good_ending_scene: String = ""
@export_file("*.tscn") var neutral_ending_scene: String = ""
@export_file("*.tscn") var bad_ending_scene: String = ""

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
		player_in_range = false
		_trigger_ending()

func _trigger_ending() -> void:
	var ending := GameState.get_ending()
	var path := ""
	match ending:
		"good": path = good_ending_scene
		"bad": path = bad_ending_scene
		_: path = neutral_ending_scene

	if path.is_empty():
		push_warning("EndingTrigger: scene untuk ending '%s' belum diisi!" % ending)
		return
	print("Ending: ", ending)
	get_tree().change_scene_to_file.call_deferred(path)

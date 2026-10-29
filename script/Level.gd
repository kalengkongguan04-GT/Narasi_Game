extends Node

func _ready() -> void:
	var spawn_name := GameState.next_spawn
	if spawn_name.is_empty():
		return
	var player := get_tree().get_first_node_in_group("player")
	var spawn := get_node_or_null("Spawns/" + spawn_name)
	if player == null:
		push_warning("level.gd: tidak ada node di grup 'player' di scene ini!")
		return
	if spawn == null:
		push_warning("level.gd: titik muncul 'Spawns/%s' tidak ditemukan!" % spawn_name)
		return
	player.global_position = spawn.global_position
	GameState.next_spawn = ""

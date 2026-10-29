extends Node

signal item_collected(id: String)
signal flag_changed(id: String, value: bool)

var items: Dictionary = {}
var flags: Dictionary = {}
var score: int = 0
var next_spawn: String = ""   # titik muncul pemain di ruangan berikutnya

func collect_item(id: String, value: int = 0) -> void:
	if items.has(id):
		return  # item yang sama tidak dihitung dua kali
	items[id] = true
	score += value
	item_collected.emit(id)

func has_item(id: String) -> bool:
	return items.has(id)

func set_flag(id: String, value: bool = true) -> void:
	flags[id] = value
	flag_changed.emit(id, value)

func get_flag(id: String) -> bool:
	return flags.get(id, false)

func get_ending() -> String:
	# SEMENTARA: ganti syaratnya sesuai dokumen cerita
	if has_item("surat_rahasia") and score >= 5:
		return "good"
	elif score >= 0:
		return "neutral"
	else:
		return "bad"

func reset() -> void:
	items.clear()
	flags.clear()
	score = 0
	next_spawn = ""

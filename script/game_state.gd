#BUAT NYIMPEN DATA GAME KIBALTNYA SYSTEM
extends Node

const GOOD_REQUIRED_ITEMS: Array[String] = []
const GOOD_MIN_SCORE := 5
const BAD_MAX_SCORE := 0

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
	if get_flag("jujur_soal_surat") and score >= GOOD_MIN_SCORE:
		return "good"
	if get_flag("menyembunyikan_surat") or score <= BAD_MAX_SCORE:
		return "bad"
	return "neutral"
	
func reset() -> void:
	items.clear()
	flags.clear()
	score = 0
	next_spawn = ""

func add_score_once(id: String, value: int) -> void:
	if get_flag(id):
		return
	set_flag(id)
	score += value

extends Node
# Didaftarkan sebagai Autoload dengan nama "SaveManager"
# (Project > Project Settings > Globals > Autoload)

const SAVE_PATH := "user://savegame.json"
const SAVE_VERSION := 1

# Data save terakhir yang dibaca/ditulis
var data := {}

# Cek apakah file save sudah ada
func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

# Mulai game baru: kosongkan GameState lalu simpan data awal
func new_game(first_room: String) -> void:
	GameState.reset()
	data = {}
	save_game(first_room)

# Simpan kondisi GameState + ruangan tujuan.
# Panggil dengan nama scene ruangan yang akan dimasuki pemain.
func save_game(room: String = "") -> void:
	if not room.is_empty():
		data["room"] = room
	data["version"] = SAVE_VERSION
	data["spawn"] = GameState.next_spawn
	data["items"] = GameState.items
	data["flags"] = GameState.flags
	data["score"] = GameState.score

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Gagal menyimpan: " + str(FileAccess.get_open_error()))
		return
	file.store_string(JSON.stringify(data))

# Baca file save lalu pulihkan ke GameState. Hasil true kalau berhasil.
func load_game() -> bool:
	if not has_save():
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Gagal membaca save: " + str(FileAccess.get_open_error()))
		return false
	var parsed = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		push_error("File save rusak atau formatnya salah.")
		return false

	data = parsed
	GameState.reset()
	GameState.items = data.get("items", {})
	GameState.flags = data.get("flags", {})
	GameState.score = int(data.get("score", 0))   # JSON menyimpan angka sebagai float
	GameState.next_spawn = str(data.get("spawn", ""))
	return true

# Nama scene ruangan terakhir yang tersimpan ("" kalau belum ada)
func get_saved_room() -> String:
	return str(data.get("room", ""))

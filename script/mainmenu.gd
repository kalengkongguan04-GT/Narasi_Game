extends Control

# Pilih scene langsung di Inspector (klik node root menu, lihat bagian Script Variables).
# Tidak perlu mengetik path, tinggal klik ikon folder.
@export_file("*.tscn") var game_scene: String = ""       # ruangan pertama saat New Game
@export_file("*.tscn") var credit_scene: String = ""     # opsional
@export_file("*.tscn") var settings_scene: String = ""   # opsional

@onready var popup: CanvasLayer = %startpopup
@onready var continue_button: Button = %continue
@onready var newgame_button: Button = %newgame

func _ready() -> void:
	popup.visible = false

	%start.pressed.connect(_on_start_pressed)
	%exit.pressed.connect(_on_exit_pressed)
	%settings.pressed.connect(_on_settings_pressed)
	%Credit.pressed.connect(_on_credit_pressed)

	continue_button.pressed.connect(_on_continue_pressed)
	newgame_button.pressed.connect(_on_newgame_pressed)
	%back.pressed.connect(_close_popup)

	%start.grab_focus()

# --- Menu utama ---
func _on_start_pressed() -> void:
	if not SaveManager.has_save():
		# Belum ada save: langsung mulai game baru
		_start_new_game()
		return

	# Sudah ada save: tampilkan pilihan Continue / New Game
	popup.visible = true
	continue_button.grab_focus()

func _on_settings_pressed() -> void:
	_go_to(settings_scene, "settings_scene")

func _on_credit_pressed() -> void:
	_go_to(credit_scene, "credit_scene")

func _on_exit_pressed() -> void:
	get_tree().quit()

# --- Popup Continue / New Game ---
func _on_continue_pressed() -> void:
	if not SaveManager.load_game():
		# Save gagal dibaca: mulai dari awal saja
		_start_new_game()
		return

	var room: String = SaveManager.get_saved_room()
	if room.is_empty() or not ResourceLoader.exists(room):
		room = game_scene   # cadangan kalau ruangan tersimpan tidak ditemukan
	_go_to(room, "game_scene")

func _on_newgame_pressed() -> void:
	_start_new_game()

func _close_popup() -> void:
	popup.visible = false
	%start.grab_focus()

# --- Fungsi bantu ---
func _start_new_game() -> void:
	if game_scene.is_empty():
		push_error("mainmenu: 'game_scene' belum diisi di Inspector!")
		return
	SaveManager.new_game(game_scene)
	_go_to(game_scene, "game_scene")

# Pindah scene dengan pengecekan supaya tidak error kalau kosong/salah
func _go_to(path: String, label: String) -> void:
	if path.is_empty():
		push_warning("mainmenu: '%s' belum diisi di Inspector." % label)
		return
	if not ResourceLoader.exists(path):
		push_error("mainmenu: file scene tidak ditemukan: " + path)
		return
	get_tree().change_scene_to_file(path)

# Esc menutup popup
func _unhandled_input(event: InputEvent) -> void:
	if popup.visible and event.is_action_pressed("ui_cancel"):
		_close_popup()
		get_viewport().set_input_as_handled()

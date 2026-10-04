extends Node
## Global state: progress (beaten maps / unlocked towers), current selection, settings.

const MapsData = preload("res://scripts/data/maps_data.gd")
const SAVE_PATH := "user://pixel_td_save.json"

var beaten := {}            # map_id -> Array of beaten difficulty indices
var sfx_volume := 0.8
var selected_map := "meadow"
var selected_difficulty := 1

var _tex_cache := {}


var _cursor_scale := 0


func _ready() -> void:
	load_progress()
	if DisplayServer.get_name() != "headless":
		get_window().size_changed.connect(_update_cursor)
		_update_cursor()
	if OS.get_cmdline_user_args().has("--unlock-all"):
		for m in MapsData.ORDER:
			beaten[m] = [0, 1, 2, 3]


## Pixel cursors, scaled with the window so they keep the same size as the game's pixels.
func _update_cursor() -> void:
	var w := get_window().size
	var sc := maxi(1, int(minf(w.x / 640.0, w.y / 360.0)))
	if sc == _cursor_scale:
		return
	_cursor_scale = sc
	for c in [["arrow", Input.CURSOR_ARROW, Vector2(1, 1)], ["hand", Input.CURSOR_POINTING_HAND, Vector2(3, 1)],
			["cross", Input.CURSOR_CROSS, Vector2(5, 5)]]:
		var img: Image = (load("res://assets/ui/cursor_%s.png" % c[0]) as Texture2D).get_image()
		img.convert(Image.FORMAT_RGBA8)
		img.resize(img.get_width() * sc, img.get_height() * sc, Image.INTERPOLATE_NEAREST)
		Input.set_custom_mouse_cursor(ImageTexture.create_from_image(img), c[1], c[2] * sc)


func set_cursor(shape: int) -> void:
	if Input.get_current_cursor_shape() != shape:
		Input.set_default_cursor_shape(shape)


func tex(path: String) -> Texture2D:
	if not _tex_cache.has(path):
		_tex_cache[path] = load(path)
	return _tex_cache[path]


# ---------------------------------------------------------------- progress
func is_beaten(map_id: String, diff: int) -> bool:
	return beaten.has(map_id) and (beaten[map_id] as Array).has(diff)


func best_beaten(map_id: String) -> int:
	var best := -1
	if beaten.has(map_id):
		for d in beaten[map_id]:
			best = maxi(best, int(d))
	return best


func is_tower_unlocked(tower_id: String) -> bool:
	var u: Dictionary = Defs.TOWERS[tower_id]["unlock"]
	if u.is_empty():
		return true
	return best_beaten(u["map"]) >= int(u["difficulty"])


func unlock_text(tower_id: String) -> String:
	var u: Dictionary = Defs.TOWERS[tower_id]["unlock"]
	if u.is_empty():
		return ""
	return "Beat %s on %s" % [MapsData.MAPS[u["map"]]["name"], Defs.DIFFICULTIES[u["difficulty"]]["name"]]


## Records a victory and returns the list of tower ids that just became unlocked.
func record_win(map_id: String, diff: int) -> Array:
	var before := {}
	for t in Defs.TOWER_ORDER:
		before[t] = is_tower_unlocked(t)
	if not beaten.has(map_id):
		beaten[map_id] = []
	if not (beaten[map_id] as Array).has(diff):
		beaten[map_id].append(diff)
	save_progress()
	var newly := []
	for t in Defs.TOWER_ORDER:
		if not before[t] and is_tower_unlocked(t):
			newly.append(t)
	return newly


func save_progress() -> void:
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify({"beaten": beaten, "sfx_volume": sfx_volume}))


func load_progress() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not f:
		return
	var data = JSON.parse_string(f.get_as_text())
	if typeof(data) != TYPE_DICTIONARY:
		return
	var b = data.get("beaten", {})
	if typeof(b) == TYPE_DICTIONARY:
		for k in b:
			var arr := []
			for d in b[k]:
				arr.append(int(d))
			beaten[k] = arr
	sfx_volume = float(data.get("sfx_volume", 0.8))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F11:
		var w := get_window()
		if w.mode == Window.MODE_FULLSCREEN or w.mode == Window.MODE_EXCLUSIVE_FULLSCREEN:
			w.mode = Window.MODE_WINDOWED
		else:
			w.mode = Window.MODE_FULLSCREEN

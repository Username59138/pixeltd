extends Node
## Global state: progress (beaten maps / unlocked towers), current selection, settings.

const MapsData = preload("res://scripts/data/maps_data.gd")
const SAVE_PATH := "user://pixel_td_save.json"

var beaten := {}            # map_id -> Array of beaten difficulty indices
var sfx_volume := 0.8
var fullscreen := false

# ---------------------------------------------------------------- key bindings
# Physical keys (layout independent: E stays E on a Russian layout). Esc / right click are fixed (cancel, back).
const ACTIONS := ["tower_1", "tower_2", "tower_3", "tower_4", "tower_5", "tower_6", "tower_7", "upgrade", "sell", "target",
	"next_wave", "speed", "pause"]
const ACTION_NAMES := {"tower_1": "Tower 1", "tower_2": "Tower 2", "tower_3": "Tower 3", "tower_4": "Tower 4",
	"tower_5": "Tower 5", "tower_6": "Tower 6", "tower_7": "Tower 7", "upgrade": "Upgrade", "sell": "Sell", "target": "Targeting mode",
	"next_wave": "Next wave", "speed": "Game speed", "pause": "Pause"}
const DEFAULT_KEYS := {"tower_1": KEY_1, "tower_2": KEY_2, "tower_3": KEY_3, "tower_4": KEY_4, "tower_5": KEY_5,
	"tower_6": KEY_6, "tower_7": KEY_7, "upgrade": KEY_E, "sell": KEY_X, "target": KEY_T, "next_wave": KEY_SPACE, "speed": KEY_F, "pause": KEY_P}
var keys := DEFAULT_KEYS.duplicate()
var selected_map := "meadow"
var selected_difficulty := 1

# ---------------------------------------------------------------- map unlocks
# The first win on a map of tier X gives a key of tier X. A key of tier X opens any locked map of tier X or X+1.
const TIERS := ["Beginner", "Intermediate", "Advanced", "Expert"]
const START_MAPS := ["meadow"]
var unlocked_maps: Array = START_MAPS.duplicate()
var map_keys: Array = []        # tier index of every unused key
var all_maps_open := false      # dev flag --unlock-all
var last_key_tier := -1         # key earned by the last recorded win, -1 if none

# ---------------------------------------------------------------- seasonal events
# Halloween: maps with a "halloween" variant (Green Meadow) get their autumn look. Gameplay is unchanged.
# Dev flags --halloween / --no-halloween force it on or off.
const HALLOWEEN_FROM := 1010   # month * 100 + day, inclusive: Oct 10 - Nov 7
const HALLOWEEN_TO := 1107
var halloween := false

var _tex_cache := {}


var _cursor_scale := 0
var _real_beaten = null
var save_fake := false   # dev flag --save-fake: progress from cheats / --unlock-all is written to the save
var _no_save := false     # dev flag --reset-data without --save-fake: play with a clean slate, never touch the save


func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	save_fake = args.has("--save-fake")
	load_progress()
	var today := Time.get_date_dict_from_system()
	var md := int(today["month"]) * 100 + int(today["day"])
	halloween = md >= HALLOWEEN_FROM and md <= HALLOWEEN_TO
	if args.has("--halloween"):
		halloween = true
	elif args.has("--no-halloween"):
		halloween = false
	if args.has("--reset-data"):
		_reset_data()
	if DisplayServer.get_name() != "headless":
		get_window().size_changed.connect(_update_cursor)
		_update_cursor()
		if fullscreen:
			set_fullscreen(true)
	if args.has("--unlock-all"):
		if not save_fake:
			_real_beaten = beaten.duplicate(true)   # dev flag: never written to the save file
		for m in MapsData.ORDER:
			beaten[m] = [0, 1, 2, 3]
		all_maps_open = true
		if save_fake:
			unlocked_maps = MapsData.ORDER.duplicate()
			save_progress()


## Dev flag --reset-data: start from default progress and settings. With --save-fake the save file is
## deleted, otherwise the real save is left alone and nothing is written this session.
func _reset_data() -> void:
	beaten = {}
	sfx_volume = 0.8
	fullscreen = false
	keys = DEFAULT_KEYS.duplicate()
	unlocked_maps = START_MAPS.duplicate()
	map_keys = []
	if save_fake:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
	else:
		_no_save = true


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


func tier_of(map_id: String) -> int:
	return TIERS.find(MapsData.MAPS[map_id]["tier"])


## Current season of a map: "halloween" or "" (normal look).
func map_variant(map_id: String) -> String:
	if halloween and (MapsData.MAPS[map_id]["variants"] as Dictionary).has("halloween"):
		return "halloween"
	return ""


func map_bg(map_id: String) -> String:
	var v := map_variant(map_id)
	return MapsData.MAPS[map_id]["variants"][v]["bg"] if v != "" else MapsData.MAPS[map_id]["bg"]


func map_thumb(map_id: String) -> String:
	var v := map_variant(map_id)
	return MapsData.MAPS[map_id]["variants"][v]["thumb"] if v != "" else MapsData.MAPS[map_id]["thumb"]


func is_map_unlocked(map_id: String) -> bool:
	return all_maps_open or unlocked_maps.has(map_id) or beaten.has(map_id)


## Index in map_keys of the key that would open this map, -1 if none fits.
## Spends the lowest fitting key: a higher one opens more maps.
func key_for(map_id: String) -> int:
	var t := tier_of(map_id)
	var best := -1
	for i in map_keys.size():
		var k: int = map_keys[i]
		if (k == t or k == t - 1) and (best < 0 or k < int(map_keys[best])):
			best = i
	return best


func unlock_map(map_id: String) -> bool:
	var i := key_for(map_id)
	if i < 0 or is_map_unlocked(map_id):
		return false
	map_keys.remove_at(i)
	unlocked_maps.append(map_id)
	save_progress()
	return true


## "Beginner or Intermediate": the tiers a key of this tier opens.
func key_reach_text(tier: int) -> String:
	if tier + 1 < TIERS.size():
		return "%s or %s" % [TIERS[tier], TIERS[tier + 1]]
	return TIERS[tier]


## Records a victory and returns the list of tower ids that just became unlocked (see last_key_tier for map keys).
func record_win(map_id: String, diff: int) -> Array:
	var before := {}
	for t in Defs.TOWER_ORDER:
		before[t] = is_tower_unlocked(t)
	last_key_tier = -1
	if not beaten.has(map_id) or (beaten[map_id] as Array).is_empty():
		last_key_tier = tier_of(map_id)
		map_keys.append(last_key_tier)
		if not unlocked_maps.has(map_id):
			unlocked_maps.append(map_id)
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
	if _no_save:
		return
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify({"beaten": beaten if _real_beaten == null else _real_beaten, "sfx_volume": sfx_volume, "fullscreen": fullscreen,
			"keys": keys, "unlocked_maps": unlocked_maps, "map_keys": map_keys}))


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
	if data.has("unlocked_maps"):
		for m in data.get("unlocked_maps", []):
			if MapsData.MAPS.has(m) and not unlocked_maps.has(m):
				unlocked_maps.append(m)
		for k in data.get("map_keys", []):
			map_keys.append(int(k))
	else:
		# save from before map unlocks: every beaten map stays open and pays out its key
		for m in beaten:
			if MapsData.MAPS.has(m) and not (beaten[m] as Array).is_empty():
				if not unlocked_maps.has(m):
					unlocked_maps.append(m)
				map_keys.append(tier_of(m))
	sfx_volume = float(data.get("sfx_volume", 0.8))
	fullscreen = bool(data.get("fullscreen", false))
	var k = data.get("keys", {})
	if typeof(k) == TYPE_DICTIONARY:
		for a in k:
			if ACTIONS.has(a):
				keys[a] = int(k[a])


## Which action (if any) this key press triggers.
func action_for(event: InputEvent) -> String:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return ""
	var pk: int = event.physical_keycode if event.physical_keycode != 0 else event.keycode
	for a in ACTIONS:
		if keys[a] == pk:
			return a
	return ""


## Human readable name of the key bound to an action, as printed on the user's keyboard.
func key_label(action: String) -> String:
	var pk: int = keys.get(action, 0)
	if pk == 0:
		return "-"
	var shown := pk
	if DisplayServer.get_name() != "headless":
		shown = DisplayServer.keyboard_get_keycode_from_physical(pk)
	return OS.get_keycode_string(shown)


## Bind a key; if another action already uses it, the two actions swap keys.
func bind_key(action: String, physical_key: int) -> void:
	for a in ACTIONS:
		if a != action and keys[a] == physical_key:
			keys[a] = keys[action]
	keys[action] = physical_key
	save_progress()


func reset_keys() -> void:
	keys = DEFAULT_KEYS.duplicate()
	save_progress()


func set_fullscreen(on: bool) -> void:
	fullscreen = on
	if DisplayServer.get_name() == "headless":
		return
	get_window().mode = Window.MODE_FULLSCREEN if on else Window.MODE_WINDOWED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F11:
		set_fullscreen(not fullscreen)
		save_progress()

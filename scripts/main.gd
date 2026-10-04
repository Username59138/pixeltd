extends Node
## Root: switches between the menu screens (with the live diorama behind them) and battles.


var ui_layer: CanvasLayer
var ui_root: Control
var demo: Node2D
var battle: Node2D
var hud: Control


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("181425"))
	ui_layer = CanvasLayer.new()
	ui_layer.layer = 10
	add_child(ui_layer)
	ui_root = Control.new()
	ui_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui_root.size = Vector2(640, 360)
	ui_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_root.theme = UI.build_theme()
	ui_layer.add_child(ui_root)
	var args := OS.get_cmdline_user_args()
	if args.has("--sim"):
		_run_sims(args)
		return
	var i := args.find("--battle")
	if i >= 0 and i + 2 < args.size():
		start_battle(args[i + 1], int(args[i + 2]))
		if args.has("--bot"):
			_bot_drive()
		if args.has("--fxtest"):
			battle.cash = 99999
			for t in [[Vector2i(7, 6), "flamer", 3], [Vector2i(9, 5), "knight", 2], [Vector2i(9, 3), "gunner", 3],
					[Vector2i(6, 3), "soldier", 2], [Vector2i(9, 8), "knight", 3], [Vector2i(9, 13), "garage", 3],
					[Vector2i(7, 10), "soldier", 3]]:
				var tw = battle.place_tower(t[1], t[0])
				for k in t[2]:
					battle.upgrade_tower(tw)
			for k in 12:
				battle.start_wave()
				battle.spawning = false
			battle.spawn_queue = []
			for k in 14:
				battle.spawn_enemy(["goblin", "ironclad", "imp", "wolf", "shaman", "ogre"][k % 6], 0, 60.0 + k * 9.0)
			battle.wave = battle.total_waves
			var boss = battle.spawn_enemy("golem", 0, 20.0)
			boss.final_boss = true
			boss.hp *= 0.7
	elif args.has("--maps"):
		show_map_select()
	elif args.has("--towers"):
		show_towers()
	else:
		show_menu()
	if args.has("--force-win") and battle:
		battle.wave = battle.total_waves
		battle.kills = 1234
		battle._finish(true)
	if args.has("--pause") and hud:
		hud.toggle_pause()
	var tv := args.find("--tower-view")
	if tv >= 0:
		for c in ui_root.get_children():
			if c.has_method("_open_tower"):
				c._open_tower(args[tv + 1])
				if tv + 2 < args.size() and args[tv + 2].is_valid_int():
					c._select_level(int(args[tv + 2]))
	if args.has("--erupt") and battle:
		battle.cash = 99999
		for t in [Vector2i(17, 7), Vector2i(19, 7), Vector2i(22, 10), Vector2i(10, 8), Vector2i(7, 9)]:
			battle.place_tower(["gunner", "soldier", "knight", "flamer", "gunner"][t.x % 5], t)
		battle.start_wave()
		battle.eruption_t = 0.3
	if args.has("--popup"):
		for c in ui_root.get_children():
			if c.has_method("_open_difficulty"):
				c._open_difficulty("gas_station")
	if args.has("--uitest"):
		_ui_test()
	var s := args.find("--shot")
	if s >= 0:
		_shot(args[s + 1], float(args[s + 2]))


# ---------------------------------------------------------------- debug helpers (CLI only)
func _shot(path: String, secs: float) -> void:
	await get_tree().create_timer(secs).timeout
	if OS.get_cmdline_user_args().has("--hover"):
		var e = battle.enemies[0] if battle and battle.enemies.size() > 0 else null
		if OS.get_cmdline_user_args().has("--hover-friendly"):
			for x in battle.enemies:
				if x.is_friendly:
					e = x
		if e:
			Input.warp_mouse(e.position * 2.0 + Vector2(0, -6))
			await get_tree().create_timer(0.2).timeout
	get_viewport().get_texture().get_image().save_png(path)
	get_tree().quit()


func _click(p: Vector2, button := MOUSE_BUTTON_LEFT) -> void:
	# viewport (640x360) -> window coordinates
	var scale := Vector2(get_window().size) / Vector2(640, 360)
	var wp := p * minf(scale.x, scale.y)
	var mv := InputEventMouseMotion.new()
	mv.position = wp
	Input.parse_input_event(mv)
	await get_tree().create_timer(0.15).timeout
	for pressed in [true, false]:
		var ev := InputEventMouseButton.new()
		ev.button_index = button
		ev.pressed = pressed
		ev.position = wp
		Input.parse_input_event(ev)
		await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout


func _find_button(root: Node, text: String) -> Button:
	for c in root.find_children("*", "Button", true, false):
		if c is Button and c.is_visible_in_tree() and (c as Button).text.begins_with(text):
			return c
	return null


func _btn_center(b: Control) -> Vector2:
	return b.get_global_rect().get_center()


func _ui_test() -> void:
	await get_tree().create_timer(0.5).timeout
	await _click(_btn_center(_find_button(ui_root, "PLAY")))
	print("UITEST after PLAY: ", ui_root.get_child(ui_root.get_child_count() - 1).get_script().resource_path)
	await _click(Vector2(100, 90))  # first map card
	var b := _find_button(ui_root, "")
	await _click(Vector2(450, 110))  # MEDIUM button in popup
	print("UITEST battle started: ", battle != null, " map=", battle.map_id if battle else "", " diff=", battle.diff_idx if battle else -1)
	var shop: Button = hud.shop_buttons["gunner"]
	await _click(_btn_center(shop))
	print("UITEST placing: ", battle.placing)
	await _click(Vector2(10 * 16 + 8, 6 * 16 + 8))
	print("UITEST towers: ", battle.towers.size(), " cash=", battle.cash, " selected=", battle.selected != null)
	await _click(_btn_center(hud.up_btn))
	print("UITEST level after upgrade: ", battle.selected.level if battle.selected else -1)
	await _click(_btn_center(hud.target_btn))
	print("UITEST target mode: ", battle.selected.target_mode if battle.selected else -1)
	await _click(Vector2(300, 300), MOUSE_BUTTON_RIGHT)
	print("UITEST deselected: ", battle.selected == null)
	await _click(_btn_center(hud.start_btn))
	print("UITEST wave: ", battle.wave)
	var ev := InputEventKey.new()
	ev.keycode = KEY_2
	ev.pressed = true
	Input.parse_input_event(ev)
	await get_tree().process_frame
	print("UITEST key 2 -> placing: ", battle.placing)
	await get_tree().create_timer(4.0).timeout
	print("UITEST enemies on field: ", battle.enemies.size(), " kills=", battle.kills)
	get_tree().quit()


func _bot_drive() -> void:
	var Bot = load("res://scripts/debug/bot.gd")
	var bot = Bot.new(battle, ["gunner", "knight", "flamer"])
	battle.speed = 3
	while is_instance_valid(battle) and not battle.over:
		bot.step()
		await get_tree().create_timer(0.25).timeout


func _run_sims(args: Array) -> void:
	var Bot = load("res://scripts/debug/bot.gd")
	var Defs = load("res://scripts/data/defs.gd")
	var MapsData = load("res://scripts/data/maps_data.gd")
	var only_map := ""
	var k := args.find("--map")
	if k >= 0:
		only_map = args[k + 1]
	var sets := [["gunner", "knight"], ["gunner", "knight", "soldier"], ["gunner", "knight", "soldier", "garage"],
		["gunner", "knight", "soldier", "garage", "flamer"], ["flamer", "gunner", "knight"], ["gunner", "flamer", "knight"], ["flamer"], ["gunner"]]
	var si := args.find("--sets")
	if si >= 0:
		var chosen: Array = []
		for ks in String(args[si + 1]).split(","):
			chosen.append(sets[int(ks)])
		sets = chosen
	for knob in ["BUDGET_MULT", "HP_GROWTH", "BOUNTY_MULT"]:
		var ki := args.find("--" + knob)
		if ki >= 0:
			Defs.set(knob, float(args[ki + 1]))
	var only_diff := -1
	if args.find("--diff") >= 0:
		only_diff = int(args[args.find("--diff") + 1])
	for m in MapsData.ORDER:
		if only_map != "" and m != only_map:
			continue
		for d in 4:
			if only_diff >= 0 and d != only_diff:
				continue
			for allowed in sets:
				var b = Battle.new()
				b.headless = true
				add_child(b)
				b.setup(m, d)
				var bot = Bot.new(b, allowed)
				var t := 0.0
				while not b.over and t < 3600.0:
					if int(t * 60.0) % 15 == 0:
						bot.step()
					b.tick(Battle.STEP)
					t += Battle.STEP
				if args.has("--dmg"):
					var per := {}
					var spent := {}
					var cnt := {}
					for tw in b.towers.values():
						per[tw.type] = per.get(tw.type, 0) + int(tw.damage_dealt)
						spent[tw.type] = spent.get(tw.type, 0) + tw.spent
						cnt[tw.type] = cnt.get(tw.type, 0) + 1
					var out := ""
					for kk in per:
						out += "%s x%d %.1f/$  " % [kk, cnt[kk], float(per[kk]) / maxf(1.0, spent[kk])]
					print("    dmg by type: ", out)
				print("%-12s %-9s %-22s %s  wave %2d/%d  lives %3d  cash %5d  towers %d  time %ds" % [m,
					Defs.DIFFICULTIES[d]["name"], ",".join(allowed), "WIN " if b.lives > 0 and b.over else "LOSE",
					b.wave, b.total_waves, b.lives, b.cash, b.towers.size(), int(t)])
				b.queue_free()
	get_tree().quit()


func _clear_ui() -> void:
	for c in ui_root.get_children():
		c.queue_free()
	hud = null


func _ensure_demo() -> void:
	if battle:
		battle.queue_free()
		battle = null
	if demo == null:
		demo = Battle.new()
		add_child(demo)
		move_child(demo, 0)
		demo.setup("menu", 1, true)
		# warm up so the diorama is already busy
		for k in 600:
			demo.tick(Battle.STEP)


func show_menu() -> void:
	_ensure_demo()
	_clear_ui()
	var s := MenuScreen.new()
	s.main = self
	ui_root.add_child(s)


func show_map_select() -> void:
	_ensure_demo()
	_clear_ui()
	var s := MapSelect.new()
	s.main = self
	ui_root.add_child(s)


func show_towers() -> void:
	_ensure_demo()
	_clear_ui()
	var s := TowersScreen.new()
	s.main = self
	ui_root.add_child(s)


func start_battle(map_id: String, diff: int) -> void:
	Game.selected_map = map_id
	Game.selected_difficulty = diff
	_clear_ui()
	if demo:
		demo.queue_free()
		demo = null
	if battle:
		battle.queue_free()
	battle = Battle.new()
	add_child(battle)
	move_child(battle, 0)
	battle.setup(map_id, diff)
	hud = Hud.new()
	ui_root.add_child(hud)
	hud.setup(battle)
	hud.quit_to_menu.connect(show_menu)
	hud.restart.connect(func(): start_battle(map_id, diff))

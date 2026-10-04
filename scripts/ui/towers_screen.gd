class_name TowersScreen
extends Control
## Armory: tower portraits (click one for the full tower view with its upgrade path) and an enemy bestiary.


var main: Node
var content: Control
var tab_towers: Button
var tab_enemies: Button
var detail: Control

# tower view state
var cur_tower := ""
var cur_level := 0
var view_sprite: TextureRect
var view_stats: Label
var up_title: Label
var up_cost: Label
var up_desc: Label
var up_diff: Label
var circles: Array = []


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(UI.dim_rect(0.6))
	var title := UI.title("ARMORY", 16)
	title.position = Vector2(0, 8)
	title.size = Vector2(640, 20)
	add_child(title)
	tab_towers = UI.button("Towers", "blue", Vector2(80, 16))
	tab_towers.position = Vector2(236, 30)
	tab_towers.pressed.connect(func(): _show(true))
	add_child(tab_towers)
	tab_enemies = UI.button("Enemies", "gray", Vector2(80, 16))
	tab_enemies.position = Vector2(324, 30)
	tab_enemies.pressed.connect(func(): _show(false))
	add_child(tab_enemies)
	var back := UI.button("Back", "red", Vector2(70, 18))
	back.position = Vector2(8, 336)
	back.pressed.connect(func(): main.show_menu())
	add_child(back)
	_show(true)


func _show(towers: bool) -> void:
	if content:
		content.queue_free()
	content = Control.new()
	content.position = Vector2(0, 52)
	content.size = Vector2(640, 280)
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(content)
	UI.color_button(tab_towers, "blue" if towers else "gray")
	UI.color_button(tab_enemies, "gray" if towers else "blue")
	if towers:
		_build_towers()
	else:
		_build_enemies()


# ---------------------------------------------------------------- portrait grid
func _build_towers() -> void:
	var n := Defs.TOWER_ORDER.size()
	var cw := 112
	var gap := 8
	var x0 := (640 - (n * cw + (n - 1) * gap)) / 2
	for i in n:
		var t: String = Defs.TOWER_ORDER[i]
		var d: Dictionary = Defs.TOWERS[t]
		var unlocked := Game.is_tower_unlocked(t)
		var b := UI.button("", "blue", Vector2(cw, 128))
		b.position = Vector2(x0 + i * (cw + gap), 40)
		b.size = Vector2(cw, 128)
		b.add_theme_stylebox_override("normal", UI.box("card", 4, Vector4(4, 4, 4, 4)))
		b.add_theme_stylebox_override("hover", UI.box("card_hover", 4, Vector4(4, 4, 4, 4)))
		b.add_theme_stylebox_override("pressed", UI.box("card_selected", 4, Vector4(4, 4, 4, 4)))
		b.pressed.connect(func(): _open_tower(t))
		content.add_child(b)
		var frame := PanelContainer.new()
		frame.add_theme_stylebox_override("panel", UI.box("panel_dark", 4, Vector4(3, 3, 3, 3)))
		frame.position = Vector2(8, 8)
		frame.size = Vector2(cw - 16, 92)
		frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(frame)
		var spr := UI.sprite_rect("res://assets/sprites/towers/%s.png" % d["sprite"], 4)
		if not unlocked:
			spr.modulate = Color(0, 0, 0, 0.9)
		frame.add_child(spr)
		if not unlocked:
			var lock := UI.sprite_rect("res://assets/ui/icons/lock.png", 2)
			lock.position = Vector2(cw - 34, 12)
			b.add_child(lock)
		var nl := UI.label(d["name"] if unlocked else "???", 10, Color("fee761") if unlocked else Color("8b9bb4"),
			HORIZONTAL_ALIGNMENT_CENTER)
		nl.position = Vector2(0, 106)
		nl.size = Vector2(cw, 12)
		b.add_child(nl)
	var hint := UI.label("Click a tower to see everything about it", 10, Color("8b9bb4"), HORIZONTAL_ALIGNMENT_CENTER)
	hint.position = Vector2(0, 180)
	hint.size = Vector2(640, 12)
	content.add_child(hint)


# ---------------------------------------------------------------- tower view
func _stats_at(t: String, level: int) -> Dictionary:
	var d: Dictionary = Defs.TOWERS[t]
	var st: Dictionary = (d["base"] as Dictionary).duplicate()
	for i in level:
		for k in d["upgrades"][i]["set"]:
			st[k] = d["upgrades"][i]["set"][k]
	return st


static func _fmt(key: String, v) -> String:
	if typeof(v) == TYPE_BOOL:
		return "Yes" if v else "No"
	if typeof(v) == TYPE_STRING:
		return String(v).capitalize()
	if (typeof(v) == TYPE_INT or typeof(v) == TYPE_FLOAT) and float(v) == 0.0:
		return "-"
	if Defs.PERCENT_STATS.has(key):
		return "%d%%" % int(float(v) * 100)
	return UI.fmt_num(float(v))


func _open_tower(t: String) -> void:
	Sfx.play("click")
	cur_tower = t
	var d: Dictionary = Defs.TOWERS[t]
	var unlocked := Game.is_tower_unlocked(t)
	detail = Control.new()
	detail.set_anchors_preset(Control.PRESET_FULL_RECT)
	detail.mouse_filter = Control.MOUSE_FILTER_STOP
	detail.add_child(UI.dim_rect(0.65))
	add_child(detail)
	var p := UI.panel("panel", 8)
	p.position = Vector2(16, 20)
	p.size = Vector2(608, 320)
	detail.add_child(p)
	var root := Control.new()
	root.custom_minimum_size = Vector2(592, 304)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(root)

	var close := UI.button("X", "red", Vector2(18, 18))
	close.position = Vector2(574, 0)
	close.pressed.connect(_close_tower)
	root.add_child(close)

	# left column: portrait + identity
	var frame := PanelContainer.new()
	frame.add_theme_stylebox_override("panel", UI.box("panel_dark", 4, Vector4(4, 4, 4, 4)))
	frame.position = Vector2(0, 0)
	frame.size = Vector2(150, 140)
	root.add_child(frame)
	view_sprite = UI.sprite_rect("res://assets/sprites/towers/%s.png" % d["sprite"], 6)
	if not unlocked:
		view_sprite.modulate = Color(0, 0, 0, 0.9)
	frame.add_child(view_sprite)
	var name_l := UI.label(d["name"] if unlocked else "???", 20, Color("fee761"))
	name_l.position = Vector2(0, 146)
	root.add_child(name_l)
	var role_l := UI.label(d["role"], 10, Color("c0cbdc"))
	role_l.position = Vector2(0, 170)
	root.add_child(role_l)
	var cost_row := HBoxContainer.new()
	cost_row.position = Vector2(0, 184)
	root.add_child(cost_row)
	cost_row.add_child(UI.icon("coin"))
	cost_row.add_child(UI.label("$%d" % d["cost"], 10, Color("feae34")))

	if not unlocked:
		var lock := UI.sprite_rect("res://assets/ui/icons/lock.png", 4)
		lock.position = Vector2(340, 60)
		root.add_child(lock)
		var l := UI.label("LOCKED", 20, Color("e43b44"), HORIZONTAL_ALIGNMENT_CENTER)
		l.position = Vector2(170, 110)
		l.size = Vector2(400, 20)
		root.add_child(l)
		var how := UI.label(Game.unlock_text(t), 10, Color("feae34"), HORIZONTAL_ALIGNMENT_CENTER)
		how.position = Vector2(170, 136)
		how.size = Vector2(400, 12)
		root.add_child(how)
		return

	# right column: description + stats of the selected level
	var desc := UI.label(d["desc"], 10, Color.WHITE)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.position = Vector2(166, 0)
	desc.size = Vector2(400, 24)
	desc.custom_minimum_size = Vector2(400, 0)
	root.add_child(desc)
	view_stats = UI.label("", 10, Color("c0cbdc"))
	view_stats.position = Vector2(166, 34)
	root.add_child(view_stats)

	# upgrade path: circles connected by a line
	var path_y := 210.0
	var line := Control.new()
	line.position = Vector2(0, 0)
	line.size = Vector2(592, 304)
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(line)
	var n: int = d["upgrades"].size() + 1
	var cx0 := 40.0
	var step := 70.0
	line.draw.connect(func():
		for i in n - 1:
			var a := Vector2(cx0 + i * step + 17, path_y)
			var b := Vector2(cx0 + (i + 1) * step - 17, path_y)
			line.draw_rect(Rect2(a - Vector2(0, 2), Vector2(b.x - a.x, 4)), Color("181425"))
			line.draw_rect(Rect2(a - Vector2(0, 1), Vector2(b.x - a.x, 2)),
				Defs.RAINBOW[i + 1] if i < cur_level else Color("3a4466")))
	circles.clear()
	for i in n:
		var c := Button.new()
		c.flat = true
		c.focus_mode = Control.FOCUS_NONE
		c.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		c.position = Vector2(cx0 + i * step - 18, path_y - 18)
		c.size = Vector2(36, 36)
		for st in ["normal", "hover", "pressed", "focus"]:
			c.add_theme_stylebox_override(st, StyleBoxEmpty.new())
		var idx := i
		var icon_path := "res://assets/sprites/towers/%s.png" % d["sprite"] if i == 0 else \
			"res://assets/ui/upgrades/%s.png" % d["upgrades"][i - 1]["icon"]
		var icon_tex: Texture2D = load(icon_path)
		c.draw.connect(func():
			var center := Vector2(18, 18)
			var sel := idx == cur_level
			var col: Color = Defs.RAINBOW[idx]
			c.draw_circle(center, 17, Color("181425"), true, -1.0, false)
			c.draw_circle(center, 15, col if sel else col.darkened(0.45), true, -1.0, false)
			c.draw_circle(center, 12, Color("262b44") if not sel else Color("3a4466"), true, -1.0, false)
			if c.is_hovered() and not sel:
				c.draw_arc(center, 16, 0, TAU, 32, Color.WHITE, 1.0, false)
			var sz := icon_tex.get_size() * (1 if icon_tex.get_width() > 12 else 2)
			c.draw_texture_rect(icon_tex, Rect2((center - sz / 2.0).round(), sz), false))
		c.mouse_entered.connect(c.queue_redraw)
		c.mouse_exited.connect(c.queue_redraw)
		c.pressed.connect(func(): _select_level(idx))
		root.add_child(c)
		circles.append(c)
		var cap := UI.label("Base" if i == 0 else "Lv%d" % (i + 1), 10, Defs.RAINBOW[i], HORIZONTAL_ALIGNMENT_CENTER)
		cap.position = Vector2(cx0 + i * step - 30, path_y + 20)
		cap.size = Vector2(60, 12)
		root.add_child(cap)
	circles.append(line)

	# selected upgrade info (right of the path)
	var info := PanelContainer.new()
	info.add_theme_stylebox_override("panel", UI.box("panel_dark", 4, Vector4(6, 4, 6, 4)))
	info.position = Vector2(300, 150)
	info.size = Vector2(292, 120)
	info.custom_minimum_size = Vector2(292, 120)
	root.add_child(info)
	var iv := VBoxContainer.new()
	iv.add_theme_constant_override("separation", 2)
	info.add_child(iv)
	var head := HBoxContainer.new()
	iv.add_child(head)
	up_title = UI.label("", 10, Color("fee761"))
	up_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(up_title)
	up_cost = UI.label("", 10, Color("feae34"))
	head.add_child(up_cost)
	up_desc = UI.label("", 10, Color.WHITE)
	up_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	up_desc.custom_minimum_size = Vector2(278, 0)
	iv.add_child(up_desc)
	up_diff = UI.label("", 10, Color("63c74d"))
	iv.add_child(up_diff)
	_select_level(0)


func _select_level(lv: int) -> void:
	cur_level = lv
	var d: Dictionary = Defs.TOWERS[cur_tower]
	var elite: bool = lv >= d["upgrades"].size()
	view_sprite.texture = load("res://assets/sprites/towers/%s%s.png" % [d["sprite"], "_elite" if elite else ""])
	var st := _stats_at(cur_tower, lv)
	view_stats.text = "Level %d stats:\n%s" % [lv + 1, Hud._stats_text(cur_tower, st)]
	if lv == 0:
		up_title.text = "Base - " + d["name"]
		up_cost.text = "$%d" % d["cost"]
		up_desc.text = d["role"] + "."
		up_diff.text = "Click a circle to see an upgrade."
		up_diff.add_theme_color_override("font_color", Color("8b9bb4"))
	else:
		var up: Dictionary = d["upgrades"][lv - 1]
		up_title.text = "Lv%d - %s" % [lv + 1, up["name"]]
		up_cost.text = "$%d" % up["cost"]
		up_desc.text = up["desc"]
		var prev := _stats_at(cur_tower, lv - 1)
		var lines: Array = []
		for k in up["set"]:
			if prev.get(k) == st[k]:
				continue
			lines.append("%s  %s > %s" % [Defs.STAT_LABELS.get(k, k), _fmt(k, prev[k]), _fmt(k, st[k])])
		up_diff.text = "\n".join(lines)
		up_diff.add_theme_color_override("font_color", Color("63c74d"))
	for c in circles:
		c.queue_redraw()
	Sfx.play("click")


func _close_tower() -> void:
	if detail:
		detail.queue_free()
		detail = null


# ---------------------------------------------------------------- bestiary
func _build_enemies() -> void:
	var cols := 4
	var cw := 150
	var ch := 62
	var gap := 4
	var x0 := (640 - (cols * cw + (cols - 1) * gap)) / 2
	for i in Defs.ENEMY_ORDER.size():
		var id: String = Defs.ENEMY_ORDER[i]
		var e: Dictionary = Defs.ENEMIES[id]
		var cls: int = e["class"]
		var p := UI.panel("card", 4)
		p.position = Vector2(x0 + (i % cols) * (cw + gap), (i / cols) * (ch + gap))
		p.custom_minimum_size = Vector2(cw, ch)
		p.size = Vector2(cw, ch)
		content.add_child(p)
		var h := HBoxContainer.new()
		p.add_child(h)
		var frame := PanelContainer.new()
		frame.add_theme_stylebox_override("panel", UI.box("panel_dark", 4, Vector4(2, 2, 2, 2)))
		frame.custom_minimum_size = Vector2(36, 36)
		frame.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(frame)
		frame.add_child(UI.sprite_rect("res://assets/sprites/enemies/%s.png" % id, 2 if cls < 3 else 1))
		var v := VBoxContainer.new()
		v.add_theme_constant_override("separation", 0)
		h.add_child(v)
		var top := HBoxContainer.new()
		v.add_child(top)
		top.add_child(UI.label(e["name"], 10, Color.WHITE))
		top.add_child(UI.label(Defs.CLASS_ROMAN[cls], 10, Defs.CLASS_COLORS[cls]))
		v.add_child(UI.label("HP %d   Speed %d" % [e["hp"], e["speed"]], 10, Color("c0cbdc")))
		var tr: Array = []
		if e.has("armor"):
			tr.append("Armor %d" % e["armor"])
		if e.get("fire_res", 0.0) >= 1.0:
			tr.append("Fireproof")
		elif e.has("fire_res"):
			tr.append("Fire res %d%%" % int(e["fire_res"] * 100))
		if e.has("heal"):
			tr.append("Heals")
		if e.has("split"):
			tr.append("Splits")
		v.add_child(UI.label(", ".join(tr) if tr.size() else "-", 10, Color("feae34")))
		v.add_child(UI.label("Control %d%%" % int(Defs.CLASS_EFFECT[cls] * 100), 10, Defs.CLASS_COLORS[cls]))
	var foot := UI.label("Class weakens only CONTROL (stun, slow, knockback):  I 100%  II 70%  III 40%  IV 20%.",
		10, Color("c0cbdc"), HORIZONTAL_ALIGNMENT_CENTER)
	foot.position = Vector2(0, 202)
	foot.size = Vector2(640, 12)
	content.add_child(foot)


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if detail:
			_close_tower()
		else:
			main.show_menu()
		get_viewport().set_input_as_handled()

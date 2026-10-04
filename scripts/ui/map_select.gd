class_name MapSelect
extends Control
## Map selection grid followed by a difficulty picker.

const TIER_COLORS := {"Beginner": Color("63c74d"), "Intermediate": Color("feae34"), "Advanced": Color("f77622"),
	"Expert": Color("e43b44")}

var main: Node
var popup: Control


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(UI.dim_rect(0.55))
	var title := UI.title("SELECT MAP", 16)
	title.position = Vector2(0, 8)
	title.size = Vector2(640, 20)
	add_child(title)

	var ids: Array = MapsData.ORDER
	for i in ids.size():
		var row := 0 if i < 3 else 1
		var col := i if i < 3 else i - 3
		var count := 3 if row == 0 else ids.size() - 3
		var cw := 150
		var gap := 10
		var x0 := (640 - (count * cw + (count - 1) * gap)) / 2
		var card := _map_card(ids[i])
		card.position = Vector2(x0 + col * (cw + gap), 34 + row * 148)
		add_child(card)

	var back := UI.button("Back", "red", Vector2(70, 18))
	back.position = Vector2(8, 336)
	back.pressed.connect(func(): main.show_menu())
	add_child(back)


func _map_card(id: String) -> Button:
	var m: Dictionary = MapsData.MAPS[id]
	var b := UI.button("", "blue", Vector2(150, 142))
	b.size = Vector2(150, 142)
	b.add_theme_stylebox_override("normal", UI.box("card", 4, Vector4(5, 5, 5, 5)))
	b.add_theme_stylebox_override("hover", UI.box("card_hover", 4, Vector4(5, 5, 5, 5)))
	b.add_theme_stylebox_override("pressed", UI.box("card_selected", 4, Vector4(5, 5, 5, 5)))
	b.pressed.connect(func(): _open_difficulty(id))
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 1)
	v.position = Vector2(5, 5)
	v.size = Vector2(140, 132)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(v)
	var frame := PanelContainer.new()
	frame.add_theme_stylebox_override("panel", UI.box("panel_dark", 4, Vector4(2, 2, 2, 2)))
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(frame)
	var th := UI.sprite_rect(m["thumb"])
	frame.add_child(th)
	var name_row := HBoxContainer.new()
	v.add_child(name_row)
	var nl := UI.label(m["name"], 10, Color.WHITE)
	nl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_row.add_child(nl)
	var stars := HBoxContainer.new()
	stars.add_theme_constant_override("separation", 0)
	name_row.add_child(stars)
	for d in Defs.DIFFICULTIES.size():
		var ic := UI.icon("star" if Game.is_beaten(id, d) else "star_off")
		if Game.is_beaten(id, d):
			ic.modulate = Defs.DIFFICULTIES[d]["color"].lightened(0.35)
		stars.add_child(ic)
	v.add_child(UI.label(m["tier"], 10, TIER_COLORS.get(m["tier"], Color.WHITE)))
	# tower unlock reward hint
	for t in Defs.TOWER_ORDER:
		var u: Dictionary = Defs.TOWERS[t]["unlock"]
		if not u.is_empty() and u["map"] == id:
			var h := HBoxContainer.new()
			h.add_theme_constant_override("separation", 2)
			v.add_child(h)
			var unlocked := Game.is_tower_unlocked(t)
			h.add_child(UI.icon("trophy" if unlocked else "lock"))
			var txt := "%s %s" % [Defs.TOWERS[t]["name"], "unlocked" if unlocked else
				"on " + Defs.DIFFICULTIES[u["difficulty"]]["name"]]
			h.add_child(UI.label(txt, 10, Color("63c74d") if unlocked else Color("feae34")))
	return b


func _open_difficulty(id: String) -> void:
	var m: Dictionary = MapsData.MAPS[id]
	popup = Control.new()
	popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	popup.mouse_filter = Control.MOUSE_FILTER_STOP
	popup.add_child(UI.dim_rect(0.6))
	add_child(popup)
	var p := UI.panel("panel", 8)
	p.position = Vector2(40, 30)
	p.size = Vector2(560, 300)
	popup.add_child(p)
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 10)
	p.add_child(h)
	# left: preview + info
	var left := VBoxContainer.new()
	h.add_child(left)
	left.add_child(UI.title(m["name"].to_upper(), 8, Color("fee761")))
	var frame := PanelContainer.new()
	frame.add_theme_stylebox_override("panel", UI.box("panel_dark", 4, Vector4(2, 2, 2, 2)))
	left.add_child(frame)
	frame.add_child(UI.sprite_rect(m["thumb"], 2))
	left.add_child(UI.label("Tier: " + m["tier"], 10, TIER_COLORS.get(m["tier"], Color.WHITE)))
	var desc := UI.label(m["desc"], 10, Color("c0cbdc"))
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.custom_minimum_size = Vector2(256, 0)
	left.add_child(desc)
	var paths: int = m["paths"].size()
	if paths > 1:
		left.add_child(UI.label("%d enemy paths!" % paths, 10, Color("f77622")))
	# right: difficulties
	var right := VBoxContainer.new()
	right.add_theme_constant_override("separation", 4)
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(right)
	right.add_child(UI.title("DIFFICULTY", 8, Color.WHITE))
	for d in Defs.DIFFICULTIES.size():
		var dd: Dictionary = Defs.DIFFICULTIES[d]
		var b := UI.button("", dd["btn"], Vector2(0, 50))
		b.pressed.connect(func(): Sfx.play("click"); main.start_battle(id, d))
		right.add_child(b)
		var bv := VBoxContainer.new()
		bv.add_theme_constant_override("separation", 0)
		bv.position = Vector2(6, 4)
		bv.size = Vector2(262, 44)
		bv.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(bv)
		var top := HBoxContainer.new()
		top.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bv.add_child(top)
		var nl := UI.label(dd["name"].to_upper(), 20, Color.WHITE)
		nl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		top.add_child(nl)
		if Game.is_beaten(id, d):
			top.add_child(UI.icon("star"))
			top.add_child(UI.label("Beaten", 10, Color("fee761")))
		var dl := UI.label(dd["desc"], 10, Color("ead4aa"))
		bv.add_child(dl)
		# reward note
		for t in Defs.TOWER_ORDER:
			var u: Dictionary = Defs.TOWERS[t]["unlock"]
			if not u.is_empty() and u["map"] == id and int(u["difficulty"]) <= d and not Game.is_tower_unlocked(t):
				bv.add_child(UI.label("Reward: unlocks " + Defs.TOWERS[t]["name"], 10, Color("fee761")))
	var back := UI.button("Back", "gray", Vector2(0, 18))
	back.pressed.connect(func(): popup.queue_free())
	right.add_child(back)


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if popup and is_instance_valid(popup):
			popup.queue_free()
		else:
			main.show_menu()
		get_viewport().set_input_as_handled()

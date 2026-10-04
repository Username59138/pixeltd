class_name MenuScreen
extends Control
## Title screen: logo on top, PLAY / TOWERS at the bottom, live battle diorama behind.


var main: Node
var logo: TextureRect
var t := 0.0


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	# soft darkening bands so the UI reads well on top of the busy map
	var top := ColorRect.new()
	top.color = Color(0.06, 0.05, 0.1, 0.45)
	top.position = Vector2(0, 0)
	top.size = Vector2(640, 104)
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(top)
	var bottom := ColorRect.new()
	bottom.color = Color(0.06, 0.05, 0.1, 0.55)
	bottom.position = Vector2(0, 300)
	bottom.size = Vector2(640, 60)
	bottom.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bottom)

	logo = TextureRect.new()
	logo.texture = load("res://assets/ui/logo.png")
	logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	logo.size = logo.texture.get_size() * 2
	logo.position = Vector2(roundf((640 - logo.size.x) / 2.0), 14)
	logo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(logo)
	var sub := UI.label("A  PIXEL  TOWER  DEFENSE", 10, Color("c0cbdc"), HORIZONTAL_ALIGNMENT_CENTER)
	sub.position = Vector2(0, 86)
	sub.size = Vector2(640, 12)
	add_child(sub)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.position = Vector2(320 - 136, 310)
	row.size = Vector2(272, 40)
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(row)
	var play := UI.button("PLAY", "green", Vector2(130, 36), 20)
	play.icon = load("res://assets/ui/icons/play.png")
	play.pressed.connect(func(): Sfx.play("click"); main.show_map_select())
	row.add_child(play)
	var towers := UI.button("TOWERS", "blue", Vector2(130, 36), 20)
	towers.icon = load("res://assets/ui/icons/shield.png")
	towers.pressed.connect(func(): Sfx.play("click"); main.show_towers())
	row.add_child(towers)

	var quit := UI.button("Quit", "red", Vector2(40, 16))
	quit.position = Vector2(594, 338)
	quit.pressed.connect(func(): get_tree().quit())
	add_child(quit)
	var ver := UI.label("v0.1  -  F11 fullscreen", 10, Color("8b9bb4"))
	ver.position = Vector2(6, 342)
	add_child(ver)
	# progress summary
	var stars := 0
	for m in Game.beaten:
		stars += (Game.beaten[m] as Array).size()
	var prog := HBoxContainer.new()
	prog.position = Vector2(560, 6)
	add_child(prog)
	prog.add_child(UI.icon("star"))
	prog.add_child(UI.label("%d/%d" % [stars, Game.MapsData.ORDER.size() * 4], 10, Color("fee761")))


func _process(delta: float) -> void:
	t += delta
	logo.position.y = 14 + roundf(sin(t * 2.0) * 2.0)

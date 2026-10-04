extends Node2D
## A walking enemy. Logic is driven by Battle.tick(); this node only stores state and draws itself.

var type := ""
var def: Dictionary
var cls := 1
var max_hp := 1.0
var hp := 1.0
var speed := 30.0
var armor := 0.0
var fire_res := 0.0
var bounty := 0
var radius := 6.0
var path_i := 0
var dist := 0.0
var path_len := 1.0
var alive := true
var is_friendly := false   # friendly units (garage cars) drive backwards and crash into enemies
var stats := {}             # for friendly units: the stats of the garage that sent them
var owner_tower: Node = null
var gun_cd := 0.0

# statuses
var stun_t := 0.0
var stun_immune_t := 0.0
var slow_f := 0.0
var slow_t := 0.0
var burn_dps := 0.0
var burn_t := 0.0
var burn_pierce := 0.0
var burn_src: Node = null
var burn_acc := 0.0
var heal_cd := 0.0
var flash_t := 0.0
var heal_flash_t := 0.0
var heal_lock := 0.0
var incoming := 0.0  # damage of bullets already flying at this enemy
var final_boss := false

var anim_t := 0.0
var sprite: Sprite2D
var tex_normal: Texture2D   # texture of the current view
var tex_flash: Texture2D
var views := {}             # "side" / "down" / "up" -> [texture, hit flash texture]
var view := "side"
var effect_mult := 1.0


func setup(t: String, hp_mult: float, p_i: int, p_len: float) -> void:
	if is_friendly:
		_setup_friendly(t, p_i, p_len)
		return
	type = t
	def = Defs.ENEMIES[t]
	cls = int(def["class"])
	effect_mult = Defs.CLASS_EFFECT[cls]
	max_hp = roundf(float(def["hp"]) * hp_mult)
	hp = max_hp
	speed = float(def["speed"])
	armor = float(def.get("armor", 0))
	fire_res = float(def.get("fire_res", 0.0))
	# reward grows with toughness so the economy keeps up with later waves
	bounty = maxi(1, int(roundf(float(def["bounty"]) * Defs.BOUNTY_MULT * (1.0 + 0.5 * maxf(0.0, hp_mult - 1.0)))))
	radius = float(def.get("radius", 6))
	path_i = p_i
	path_len = p_len
	heal_cd = 2.5
	anim_t = randf() * 10.0
	_make_sprite("res://assets/sprites/enemies/%s" % t)


func _setup_friendly(t: String, p_i: int, p_len: float) -> void:
	type = t
	def = Defs.VEHICLES[t]
	cls = 1
	effect_mult = 0.0   # friendly units ignore control effects
	max_hp = float(stats.get("car_hp", 24))
	hp = max_hp
	speed = float(stats.get("car_speed", 70))
	radius = float(def.get("radius", 6))
	bounty = 0
	path_i = p_i
	path_len = p_len
	anim_t = randf() * 10.0
	_make_sprite("res://assets/sprites/vehicles/%s" % t)


func _make_sprite(base: String) -> void:
	for v: String in ["side", "down", "up"]:
		var suffix := "" if v == "side" else "_" + v
		views[v] = [Game.tex(base + suffix + ".png"), Game.tex(base + suffix + "_flash.png")]
	sprite = Sprite2D.new()
	sprite.centered = true
	add_child(sprite)
	_set_view("side")


## Show the side, front (walking down) or back (walking up) view, feet always on the same line.
func _set_view(v: String) -> void:
	view = v
	tex_normal = views[v][0]
	tex_flash = views[v][1]
	sprite.texture = tex_normal
	var h := tex_normal.get_height()
	sprite.offset = Vector2(0, -h / 2.0 + 4)
	if int(tex_normal.get_width()) % 2 == 1:
		sprite.offset.x = 0.5
	if h % 2 == 1:
		sprite.offset.y += 0.5


func remaining() -> float:
	return path_len - dist


func is_stunned() -> bool:
	return stun_t > 0.0


func current_speed() -> float:
	if stun_t > 0.0:
		return 0.0
	var s := speed
	if slow_t > 0.0:
		s *= (1.0 - slow_f)
	return s


## Control effects are scaled by class (I 100% ... IV 20%).
func apply_stun(duration: float) -> void:
	if stun_immune_t > 0.0:
		return
	var d := duration * effect_mult
	if d < 0.04:
		return
	stun_t = maxf(stun_t, d)
	stun_immune_t = d + 0.35


func apply_slow(amount: float, duration: float) -> void:
	var a := amount * effect_mult
	var d := duration * effect_mult
	if a >= slow_f or slow_t <= 0.0:
		slow_f = a
	slow_t = maxf(slow_t, d)


## Burn is damage, so it is NOT reduced by class.
func apply_burn(dps: float, duration: float, pierce: float, src: Node) -> void:
	if dps >= burn_dps or burn_t <= 0.0:
		burn_dps = dps
		burn_pierce = pierce
		burn_src = src
	burn_t = maxf(burn_t, duration)


func tick_status(dt: float) -> void:
	anim_t += dt
	if stun_t > 0.0:
		stun_t -= dt
	if stun_immune_t > 0.0:
		stun_immune_t -= dt
	if slow_t > 0.0:
		slow_t -= dt
		if slow_t <= 0.0:
			slow_f = 0.0
	if flash_t > 0.0:
		flash_t -= dt
	if heal_flash_t > 0.0:
		heal_flash_t -= dt
	if heal_lock > 0.0:
		heal_lock -= dt


func update_visual(dir: Vector2) -> void:
	# roads are straight lines, so the dominant axis tells which way we are walking
	var want := view
	if absf(dir.y) > absf(dir.x):
		want = "down" if dir.y > 0.0 else "up"
	elif absf(dir.x) > 0.1:
		want = "side"
		sprite.flip_h = dir.x < 0
	if want != view:
		_set_view(want)
	if view != "side":
		sprite.flip_h = false
	var moving := current_speed() > 0.0
	var bob := 0.0
	if moving:
		bob = -roundf(absf(sin(anim_t * (6.0 + speed * 0.08))) * (1.0 if cls < 4 else 2.0))
	sprite.position = Vector2(0, bob)
	sprite.texture = tex_flash if flash_t > 0.0 else tex_normal
	if burn_t > 0.0:
		sprite.modulate = Color(1.0, 0.75, 0.6)
	elif slow_t > 0.0:
		sprite.modulate = Color(0.7, 0.85, 1.0)
	elif heal_flash_t > 0.0:
		sprite.modulate = Color(0.7, 1.0, 0.7)
	else:
		sprite.modulate = Color.WHITE
	queue_redraw()


func _draw() -> void:
	var h := tex_normal.get_height()
	# shadow
	var sw := maxf(4.0, tex_normal.get_width() * 0.35)
	draw_rect(Rect2(-sw, 3, sw * 2, 2), Color(0, 0, 0, 0.25))
	# status pixels
	if stun_t > 0.0:
		var a := anim_t * 8.0
		for i in 3:
			var ang := a + i * TAU / 3.0
			var p := Vector2(cos(ang) * 6.0, -h + sin(ang) * 2.0 - 2.0).round()
			draw_rect(Rect2(p, Vector2(1, 1)), Color("fee761"))
	if burn_t > 0.0:
		for i in 2:
			var fy := -fmod(anim_t * 20.0 + i * 5.0, 10.0)
			var fx := sin(anim_t * 9.0 + i * 2.0) * 3.0
			draw_rect(Rect2(Vector2(fx, fy - 2).round(), Vector2(1, 2)), Color("f77622"))

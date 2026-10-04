class_name Defs
extends RefCounted
## All static game data of Pixel TD: classes, difficulties, towers, enemies and the wave generator.

const MapsData = preload("res://scripts/data/maps_data.gd")

# ---------------------------------------------------------------- enemy classes
# Class only weakens CONTROL effects (stun, slow, knockback...). Damage of any kind is never reduced by class.
const CLASS_ROMAN := ["", "I", "II", "III", "IV"]
const CLASS_EFFECT := [1.0, 1.0, 0.7, 0.4, 0.2]
const CLASS_LEAK := [0, 1, 2, 5, 25]
const CLASS_COLORS := [Color.WHITE, Color("c0cbdc"), Color("63c74d"), Color("feae34"), Color("e43b44")]

# ---------------------------------------------------------------- difficulties
const DIFFICULTIES := [
	{"id": "light", "name": "Light", "lives": 200, "cash": 800, "hp": 0.8, "cost": 0.85, "waves": 20,
		"sell": 0.8, "color": Color("63c74d"), "btn": "green",
		"desc": "20 waves. Weaker enemies, cheaper towers, 200 lives."},
	{"id": "medium", "name": "Medium", "lives": 150, "cash": 650, "hp": 1.0, "cost": 1.0, "waves": 30,
		"sell": 0.7, "color": Color("0099db"), "btn": "blue",
		"desc": "30 waves. The standard challenge, 150 lives."},
	{"id": "difficult", "name": "Difficult", "lives": 100, "cash": 600, "hp": 1.12, "cost": 1.08, "waves": 40,
		"sell": 0.7, "color": Color("f77622"), "btn": "gold",
		"desc": "40 waves. Tougher enemies, pricier towers, 100 lives."},
	{"id": "hardcore", "name": "Hardcore", "lives": 1, "cash": 650, "hp": 1.12, "cost": 1.08, "waves": 40,
		"sell": 0.0, "color": Color("e43b44"), "btn": "red",
		"desc": "40 waves. ONE life. Towers can't be sold."},
]

# ---------------------------------------------------------------- towers
# "base" holds level-0 stats; each upgrade overrides some of them ("set"). Upgrades are a single line.
const TOWER_ORDER := ["gunner", "knight", "soldier", "garage", "flamer"]
const TOWERS := {
	"gunner": {
		"name": "Gunslinger", "role": "Ranged - single target", "cost": 200, "sprite": "gunner",
		"desc": "Quick pistol shots at one target. Armor reduces each bullet.",
		"unlock": {},
		"base": {"damage": 4, "rate": 2.0, "range": 72, "targets": 1, "slow": 0.0, "slow_time": 0.0,
			"kind": "physical", "armor_pierce": 0.0},
		"upgrades": [
			{"name": "Quick Draw", "icon": "quick_draw", "cost": 150, "desc": "Fire rate +50%.", "set": {"rate": 3.0}},
			{"name": "Hollow Points", "icon": "hollow_points", "cost": 340, "desc": "Damage 4 > 8. Range +12.",
				"set": {"damage": 8, "range": 84}},
			{"name": "Dual Pistols", "icon": "dual_pistols", "cost": 800,
				"desc": "Shoots 2 targets, dmg 11. Bullets slow by 35% (control).",
				"set": {"targets": 2, "damage": 11, "slow": 0.35, "slow_time": 0.7, "rate": 3.4}},
		],
	},
	"knight": {
		"name": "Knight", "role": "Melee - stuns", "cost": 250, "sprite": "knight",
		"desc": "Heavy sword. Ignores half of armor. Every 3rd hit stuns (control).",
		"unlock": {},
		"base": {"damage": 14, "rate": 0.9, "range": 30, "cleave": false, "stun_every": 3, "stun": 0.5,
			"kind": "physical", "armor_pierce": 0.5},
		"upgrades": [
			{"name": "Sharpened Blade", "icon": "sharpened_blade", "cost": 190, "desc": "Damage 14 > 24, swings faster.",
				"set": {"damage": 24, "rate": 1.1}},
			{"name": "Cleave", "icon": "cleave", "cost": 420, "desc": "Swings hit ALL enemies in range. Range +4.",
				"set": {"cleave": true, "range": 34}},
			{"name": "Champion", "icon": "champion", "cost": 1000, "desc": "Damage 50. Every 2nd hit stuns for 0.8s.",
				"set": {"damage": 50, "rate": 1.3, "stun_every": 2, "stun": 0.8, "armor_pierce": 0.75}},
		],
	},
	"soldier": {
		"name": "Soldier", "role": "Ranged - bursts, anti-armor", "cost": 300, "sprite": "soldier",
		"desc": "Assault rifle firing 3-round bursts from long range.",
		"unlock": {"map": "meadow", "difficulty": 1},
		"base": {"damage": 4, "rate": 0.8, "burst": 3, "burst_gap": 0.09, "range": 92, "armor_pierce": 0.0,
			"grenade_every": 0, "grenade_dmg": 0, "grenade_radius": 0, "kind": "physical"},
		"upgrades": [
			{"name": "AP Rounds", "icon": "ap_rounds", "cost": 230,
				"desc": "Bullets ignore 75% of armor. Damage 4 > 5.", "set": {"armor_pierce": 0.75, "damage": 5}},
			{"name": "Grenades", "icon": "grenades", "cost": 500,
				"desc": "Every 3rd burst also throws a grenade that hits a whole area.",
				"set": {"grenade_every": 3, "grenade_dmg": 40, "grenade_radius": 24}},
			{"name": "Machine Gun", "icon": "machine_gun", "cost": 1200,
				"desc": "Long 8-round bursts. Damage 5 > 7. Grenades every 2nd burst.",
				"set": {"burst": 8, "burst_gap": 0.06, "rate": 1.0, "damage": 7, "grenade_every": 2}},
		],
	},
	"garage": {
		"name": "Garage", "role": "Road - rams & knockback", "cost": 400, "sprite": "garage",
		"desc": "Build next to a road. Sends cars that drive INTO the enemies, ramming and knocking them back (control).",
		"unlock": {"map": "gas_station", "difficulty": 2},
		"base": {"interval": 6.0, "ram": 10, "hits": 3, "knock": 10, "car_speed": 70, "vehicle": "car",
			"gun_dmg": 0, "gun_rate": 0.0, "range": 0},
		"upgrades": [
			{"name": "Pickup", "icon": "pickup", "cost": 260, "desc": "Sturdier car: ram 15, comes out more often.",
				"set": {"vehicle": "pickup", "ram": 15, "interval": 5.0}},
			{"name": "Truck", "icon": "truck", "cost": 580, "desc": "Heavy truck: ram 24, hits 4, double knockback.",
				"set": {"vehicle": "truck", "ram": 24, "hits": 4, "knock": 20, "car_speed": 60}},
			{"name": "Armored Car", "icon": "armored", "cost": 1350,
				"desc": "Ram 34, hits 5 and a turret that shoots while driving.",
				"set": {"vehicle": "armored", "ram": 34, "hits": 5, "gun_dmg": 5, "gun_rate": 2.5, "interval": 4.5}},
		],
	},
	"flamer": {
		"name": "Flamethrower", "role": "Close - area burn", "cost": 400, "sprite": "flamer",
		"desc": "Sprays fire in a cone and sets enemies ablaze. Fire ignores armor.",
		"unlock": {"map": "volcano", "difficulty": 1},
		"base": {"damage": 3.5, "range": 46, "cone": 56.0, "burn": 4.0, "burn_time": 2.0, "fire_pierce": 0.0,
			"kind": "fire"},
		"upgrades": [
			{"name": "Bigger Tank", "icon": "bigger_tank", "cost": 300, "desc": "Range 46 > 58. Wider cone.",
				"set": {"range": 58, "cone": 72.0}},
			{"name": "Napalm", "icon": "napalm", "cost": 600, "desc": "Burn 4 > 12 dps for 3s. Spray dmg +50%.",
				"set": {"burn": 12.0, "burn_time": 3.0, "damage": 5.2}},
			{"name": "Blue Flame", "icon": "blue_flame", "cost": 1400, "desc": "Huge damage. Ignores half of fire resistance.",
				"set": {"damage": 10.0, "burn": 26.0, "fire_pierce": 0.5}},
		],
	},
}

# ---------------------------------------------------------------- enemies
const ENEMY_ORDER := ["slime", "rat", "goblin", "wolf", "ironclad", "imp", "shaman", "slime_king", "ogre",
	"golem", "demon"]
const ENEMIES := {
	"slime": {"name": "Slime", "class": 1, "hp": 12, "speed": 28, "bounty": 2, "radius": 6,
		"desc": "Bouncy and squishy."},
	"rat": {"name": "Sewer Rat", "class": 1, "hp": 8, "speed": 56, "bounty": 2, "radius": 5,
		"desc": "Small and very fast."},
	"goblin": {"name": "Goblin", "class": 1, "hp": 26, "speed": 34, "bounty": 3, "radius": 6,
		"desc": "Standard foot soldier."},
	"wolf": {"name": "Dire Wolf", "class": 2, "hp": 40, "speed": 56, "bounty": 5, "radius": 7,
		"desc": "Runs past slow defences."},
	"ironclad": {"name": "Ironclad", "class": 2, "hp": 80, "speed": 25, "bounty": 7, "radius": 7, "armor": 4,
		"desc": "Heavy armor. Pistol bullets barely scratch it."},
	"imp": {"name": "Fire Imp", "class": 2, "hp": 55, "speed": 40, "bounty": 6, "radius": 6, "fire_res": 1.0,
		"desc": "Born in flames. Fire does nothing."},
	"shaman": {"name": "Goblin Shaman", "class": 3, "hp": 170, "speed": 30, "bounty": 12, "radius": 7,
		"heal": 0.12, "desc": "Heals nearby enemies."},
	"slime_king": {"name": "Slime King", "class": 3, "hp": 360, "speed": 24, "bounty": 20, "radius": 9,
		"split": 6, "desc": "Bursts into slimes when defeated."},
	"ogre": {"name": "Ogre", "class": 3, "hp": 520, "speed": 22, "bounty": 25, "radius": 9, "armor": 2,
		"desc": "Big, slow and stubborn."},
	"golem": {"name": "Stone Golem", "class": 4, "hp": 4500, "speed": 15, "bounty": 150, "radius": 12,
		"armor": 8, "desc": "BOSS. Living rock. Shrugs off weak hits."},
	"demon": {"name": "Demon Lord", "class": 4, "hp": 16000, "speed": 17, "bounty": 300, "radius": 13,
		"armor": 4, "fire_res": 0.5, "desc": "FINAL BOSS. Lord of the burning pit."},
}

# first wave each enemy may appear in, and its "threat cost" for the wave budget
const POOL := [
	["slime", 1, 1.2], ["rat", 4, 1.0], ["goblin", 5, 2.6], ["wolf", 10, 4.5], ["ironclad", 11, 9.0],
	["imp", 13, 5.5], ["shaman", 16, 17.0], ["slime_king", 19, 36.0], ["ogre", 23, 52.0],
]
# readable names for stats (tower info screens)
const STAT_LABELS := {"damage": "Damage", "rate": "Attacks/s", "range": "Range", "targets": "Targets",
	"slow": "Slow", "slow_time": "Slow time", "armor_pierce": "Armor pierce", "cleave": "Cleave",
	"stun_every": "Stun every N hits", "stun": "Stun time", "burst": "Burst size", "burst_gap": "Burst gap",
	"grenade_every": "Grenade every N bursts", "grenade_dmg": "Grenade dmg", "grenade_radius": "Grenade radius",
	"interval": "Car every (s)", "ram": "Ram dmg", "hits": "Hits per car", "knock": "Knockback",
	"car_speed": "Car speed", "vehicle": "Vehicle", "gun_dmg": "Turret dmg", "gun_rate": "Turret shots/s",
	"cone": "Cone angle", "burn": "Burn dps", "burn_time": "Burn time", "fire_pierce": "Fire res. pierce"}
const PERCENT_STATS := ["slow", "armor_pierce", "fire_pierce"]
const RAINBOW := [Color("e43b44"), Color("fee761"), Color("63c74d"), Color("b25aff")]

# global knobs used for balancing
static var BUDGET_MULT := 1.0
static var HP_GROWTH := 1.0
static var BOUNTY_MULT := 2.5
const BOSS_TYPES := ["golem", "demon"]
const SPACING := {"slime": 0.55, "rat": 0.35, "goblin": 0.6, "wolf": 0.45, "ironclad": 0.9, "imp": 0.6,
	"shaman": 1.4, "slime_king": 1.8, "ogre": 2.2, "golem": 6.0, "demon": 6.0}


static func enemy_hp_scale(wave: int) -> float:
	return 1.0 + (0.03 * float(wave - 1) + 0.0006 * float((wave - 1) * (wave - 1))) * HP_GROWTH


static func wave_bonus(wave: int) -> int:
	return 60 + wave * 4


## Returns {"spawns": [[time, type], ...], "boss": bool}
static func build_wave(wave: int, total: int, seed_base: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_base * 1000 + wave * 7919
	var spawns: Array = []
	var budget := (6.0 + wave * 2.5 + wave * wave * 0.9) * BUDGET_MULT
	if wave <= 10:
		budget *= 0.55 + 0.045 * wave   # gentle early game
	elif wave > 20:
		budget *= 1.0 + 0.012 * (wave - 20)  # late game pressure
	var boss := false
	# boss waves
	var boss_list: Array = []
	if wave == total:
		if total >= 40:
			boss_list = ["demon"]
		elif total >= 30:
			boss_list = ["golem", "golem"]
		else:
			boss_list = ["golem"]
	elif wave == 20 and total > 20:
		boss_list = ["golem"]
	elif wave == 30 and total > 30:
		boss_list = ["golem", "golem"]
	if boss_list.size() > 0:
		boss = true
		budget *= 0.45
	# early hand-tuned waves
	var t := 0.0
	var avail: Array = []
	for p in POOL:
		if wave >= p[1]:
			avail.append(p)
	var groups := 1
	if wave >= 4:
		groups = 2
	if wave >= 12:
		groups = 3
	if wave >= 26:
		groups = 4
	var used: Array = []
	for g in groups:
		# prefer newer enemy types, avoid repeating a type inside one wave
		var p: Array = []
		for attempt in 8:
			var idx := avail.size() - 1 - int(pow(rng.randf(), 1.6) * avail.size())
			p = avail[clampi(idx, 0, avail.size() - 1)]
			if not used.has(p[0]) or used.size() >= avail.size():
				break
		used.append(p[0])
		var share := budget / groups
		var count := maxi(1, int(round(share / p[2])))
		count = mini(count, 60)
		var gap: float = SPACING[p[0]] * (0.9 if wave > 20 else (1.6 if wave <= 5 else 1.0))
		for i in count:
			spawns.append([t, p[0]])
			t += gap
		t += 1.2
	for b in boss_list:
		spawns.append([t + 1.0, b])
		t += SPACING[b]
	spawns.sort_custom(func(a, b): return a[0] < b[0])
	return {"spawns": spawns, "boss": boss}
